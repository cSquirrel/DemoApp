//
//  ContentView.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import SwiftUI
import Combine


extension Collection where Element == LaunchModel {
    
    func onlyMatching(_ matchingCriteria: FilterCriteria) -> [LaunchModel] {
        return self.filter { matchingCriteria.matches($0) }
    }
    
    func sortedByDate(order: ComparisonResult) -> [Self.Element] {
        return self
            .sorted { (launchInfoLeft, launchInfoRight) -> Bool in
                return launchInfoLeft.launchDateTime.compare(launchInfoRight.launchDateTime) == order
            }
    }
}

class MainViewState: ObservableObject {
    
    @Published var companyInfo: ContentState<String> = .fetching
    @Published var allLaunches: ContentState<[LaunchModel]> = .fetching
    @Published var canFilter: Bool = true
    @Published var canRefresh: Bool = true
    
    @Published var filterCriteriaYear: String = ""
    @Published var filterCriteriaStatus: Bool? = nil
    @Published var sortingOrder: Bool = true
    private var filterCriteria = CurrentValueSubject<FilterCriteria, Never>(DefaultFilterCriteria.noFilter)
    
    @Published var selectedLaunch: LaunchModel? = nil
    
    private let viewModelProvider: ViewModelProvider
    private let networkStatus: AnyPublisher<NetworkStatus, Never>
    private var bag = Array<AnyCancellable>()
    
    init(viewModelProvider vmp: ViewModelProvider, networkStatus ns: AnyPublisher<NetworkStatus, Never>) {
        
        viewModelProvider = vmp
        networkStatus = ns
        
        Publishers
            .CombineLatest($filterCriteriaYear, $filterCriteriaStatus)
            .dropFirst() // NOTE: dropFirst because CombineLatest will send the initial value which is not wanted
            .map { DefaultFilterCriteria(year: $0, status: $1)}
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] in self?.filterCriteria.send($0) }
            .store(in: &bag)
        
        filterCriteria
            .sink { [weak self] _ in
            self?.fetchData()
        }
        .store(in: &bag)
        
        $sortingOrder.sink { [weak self] _ in
            self?.fetchData()
        }
        .store(in: &bag)

        $allLaunches
            .canFilterData()
            .assign(to: \.canFilter, on: self)
            .store(in: &bag)
        
        $allLaunches
            .canRefreshData(networkStatus: networkStatus)
            .assign(to: \.canRefresh, on: self)
            .store(in: &bag)
    }
    
    func refreshData() {
        fetchData(forceReload: true)
    }
    
    func fetchData(forceReload: Bool = false) {
        
        companyInfo = .fetching
        allLaunches = .fetching
        
        let companyInfoSource = viewModelProvider
            .fetchCompanyInfo(forceReload: forceReload)
            .share()
        
        let allLaunchesSource = viewModelProvider
            .fetchAllLaunches(criteria: filterCriteria.value,
                              order: (sortingOrder ? .orderedAscending : .orderedDescending ),
                              forceReload: forceReload)
            .share()

        companyInfoSource
            .assign(to: \.companyInfo, on: self)
            .store(in: &bag)

        allLaunchesSource
            .assign(to: \.allLaunches, on: self)
            .store(in: &bag)
    
    }
}

extension Publisher where Output == ContentState<[LaunchModel]>, Failure == Never {
    
    func canFilterData() -> AnyPublisher<Bool, Never> {
        return self
            .map { (state) -> Bool in
            switch state {
            case .loaded:
                return true
            default:
                return false
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    func canRefreshData(networkStatus: AnyPublisher<NetworkStatus, Never>) -> AnyPublisher<Bool, Never> {
        return self
            .map { (state) -> Bool in
                switch state {
                case .fetching:
                    return false
                default:
                    return true
                    
                }
            }
            .combineLatest(networkStatus, { (flag, networkStatus) -> Bool in
                guard flag else { return false }
                
                switch networkStatus {
                case .connected:
                    return true
                default:
                    return false
                }
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

struct MainView: View {
    
    @ObservedObject var state: MainViewState
    @State var showFilter: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if showFilter {
                    FilterView(year: $state.filterCriteriaYear,
                               status: $state.filterCriteriaStatus,
                               sortAscending: $state.sortingOrder)
                        .transition(.move(edge: .top))
                }
                List {
                    Section(header: Text("COMPANY")) {
                        RemoteContentView(state: $state.companyInfo) { content in
                            Text(content)
                        }
                    }
                    
                    Section(header: Text("LAUNCHES")) {
                        RemoteContentView(state: $state.allLaunches) { launchModel in
                            AllLaunchModelsView(selectedLaunch: $state.selectedLaunch, model: launchModel)
                        }
                    }
                }.listStyle(PlainListStyle())
            }
        .navigationBarTitle("SpaceX", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    state.refreshData()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(!state.canRefresh)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilter.toggle()
                } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                .disabled(!state.canFilter)
            }
        }
            .actionSheet(item: $state.selectedLaunch) { createActionSheet(launchModel: $0) }
        }
    }
    
    func createActionSheet(launchModel: LaunchModel) -> ActionSheet {
        let buttons: [ActionSheet.Button] = actionSheetButtons(launchModel: launchModel)
        let title = Text(launchModel.missionName)
        let message: Text = buttons.count > 1 ? Text("Select media to display") : Text("There is no media to display")
        return ActionSheet(title: title, message: message, buttons: buttons)
    }
    
    func actionSheetButtons(launchModel: LaunchModel) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        if let articleLink = launchModel.links.articleLink {
            buttons.append(.default(Text("Article"), action: {
                openExternalUrl(articleLink)
            }))
        }
        if let videolink = launchModel.links.videoLink {
            buttons.append(.default(Text("Video"), action: {
                openExternalUrl(videolink)
            }))
        }
        if let wikipedia = launchModel.links.wikipediaLink {
            buttons.append(.default(Text("Wikipedia"), action: {
                openExternalUrl(wikipedia)
            }))
        }
        buttons.append(.cancel())
        
        return buttons
    }
    
    func openExternalUrl(_ url: URL) {
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//
//    static let dataSource = RemoteDataSource()
//
//    static var previews: some View {
//        ContentView(dataSource: dataSource)
//    }
//}
