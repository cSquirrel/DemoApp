//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import SwiftUI
import Combine

class AppController: ObservableObject {
    
    enum AppState {
        case initialising
        case ready(MainViewState)
        case failed
        case noNetwork
    }
    
    @Published var state: AppState = .initialising
    
    fileprivate var imageManager: RemoteImageManager? = nil
    
    private let networkMonitor = DefaultNetworkMonitor()
    private var bag = Array<AnyCancellable>()
    private var networkMonitorCancellable: AnyCancellable?
    
    func initialise() {
        guard case .initialising = state else {
            return
        }
        
        state = .initialising
        
        // cancel the network status observation if app is ready and presenting
        // the subsequent views will deal with network status then
        $state.sink { [weak self] state in
            guard case .ready(_) = state else { return }
            self?.networkMonitorCancellable?.cancel()
        }
        .store(in: &bag)
        
        // monitor the network status until the app is ready to present
        networkMonitorCancellable =
            networkMonitor
                .networkStatus
                .sink { [weak self] (networkStatus: NetworkStatus) in
                guard let strongSelf = self else { return }

                var newState: AppState
                switch networkStatus {
                case .connected:
                    newState = strongSelf.createModel()
                case .noNetwork:
                    newState = .noNetwork
                }
                
                DispatchQueue.main.async {
                    strongSelf.state = newState
                }
            }
    }
    
    private func createModel() -> AppState {
        
        let urlCache = createUrlCache()
        let urlSession = createUrlSession(urlCache: urlCache)
        
        let http = HttpFetcher(session: urlSession)
        let urlFetcher = CachedHttpFetcher(wrapped: http, urlCache: urlCache)
        
        imageManager = RemoteImageManager(urlFetcher: urlFetcher)
        
        let networkMonitor = DefaultNetworkMonitor()
        
        do {
            let viewModelProvider = try createViewModelProvider(urlFetcher: urlFetcher)
            
            let model = MainViewState(viewModelProvider: viewModelProvider, networkStatus: networkMonitor.networkStatus)
            
            return .ready(model)
        } catch {
            return .failed
        }

    }
    
    private func createUrlCache() -> URLCache {
        let cacheDirectory = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String).appendingFormat("/\(Bundle.main.bundleIdentifier ?? "cache")/" )
        let diskCacheSize = 10*1024*1024 // 10M
        let memoryCacheSize = 512*1024 // 512k
        let urlCache = URLCache(memoryCapacity: memoryCacheSize,
                                diskCapacity: diskCacheSize,
                                diskPath: cacheDirectory)
        return urlCache
    }
    
    private func createUrlSession(urlCache: URLCache) -> URLSession {

        let config = URLSessionConfiguration.default
        config.urlCache = urlCache
        let urlSession = URLSession(configuration: config)
        
        return urlSession
    }
    
    private func createLiveViewModelProviderFactory(urlFetcher: UrlFetcher) throws -> ViewModelProviderFactory {
        
        let apiConfigUrl = Bundle.main.url(forResource: "APIConfiguration.json", withExtension: nil)!
        let apiConfigData = try Data(contentsOf: apiConfigUrl)
        let apiConfiguration = try JSONDecoder().decode(APIConnectorConfiguration.self, from: apiConfigData)
        
        let api = DefaultAPIConnector(configuration: apiConfiguration, urlFetcher: urlFetcher)
        let result = LiveViewModelProviderFactory(urlFetcher: urlFetcher, api: api)
        return result
    }
    
    private func createViewModelProvider(urlFetcher: UrlFetcher) throws -> ViewModelProvider {
        let viewModelProviderFactory: ViewModelProviderFactory
        var useMockProvider = false

        #if DEBUG
        if CommandLine.arguments.contains("-useMockProvider") {
            // NOTE: UI Test uses mock provider
            useMockProvider = true
        }
        #endif

        if useMockProvider {
            viewModelProviderFactory = MockViewModelProviderFactory()
        } else {
            viewModelProviderFactory = try createLiveViewModelProviderFactory(urlFetcher: urlFetcher)
        }
        
        let viewModelProvider = viewModelProviderFactory.create()
        
        return viewModelProvider
    }
    
}

@main
struct SpaceXApp: App {
    
    @ObservedObject var controller: AppController
    
    init() {
        controller = AppController()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch controller.state {
                case .initialising:
                    Text("initialising ...")
                case .ready(let model):
                    MainView(state: model)
                        .environmentObject(controller.imageManager!)
                        .transition(.opacity)
                case .failed:
                    Text("error occured when initialising the app")
                        .transition(.opacity)
                case .noNetwork:
                    Text("no network connectivity.\nplease re-launch the app when online")
                        .transition(.opacity)
                }
            }.onAppear {
                controller.initialise()
            }
        }
    }
}
