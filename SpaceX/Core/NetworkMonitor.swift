//
//  NetworkMonitor.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
import Combine
import Network

enum NetworkStatus {
    case connected
    case noNetwork
}

protocol NetworkMonitor {
    var networkStatus: AnyPublisher<NetworkStatus, Never> { get }
}

class DefaultNetworkMonitor: NetworkMonitor {
    
    private var currentStatus = CurrentValueSubject<NetworkStatus, Never>(.noNetwork)
    private let networkMonitor = NWPathMonitor()
    private let networkMonitorQueue = DispatchQueue(label: "Network Monitor")
    
    init() {
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let strongSelf = self else { return }
            switch path.status {
            case .satisfied:
                strongSelf.currentStatus.send(.connected)
            case .unsatisfied:
                strongSelf.currentStatus.send(.noNetwork)
            default:
                strongSelf.currentStatus.send(.noNetwork)
            }
        }
        networkMonitor.start(queue: networkMonitorQueue)
        
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    var networkStatus: AnyPublisher<NetworkStatus, Never> {
        return currentStatus
            .share()
            .eraseToAnyPublisher()
    }
}
