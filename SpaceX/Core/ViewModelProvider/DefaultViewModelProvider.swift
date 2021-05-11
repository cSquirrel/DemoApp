//
//  DefaultViewModelProvider.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import Foundation
import Combine

// MARK: - Default Implementation
struct DefaultViewModelProvider {
    let dataSource: DataSource
}

extension DefaultViewModelProvider: ViewModelProvider {
    
    func fetchCompanyInfo(forceReload: Bool = false) -> AnyPublisher<ContentState<String>, Never> {
        return dataSource
            .fetchCompanyInfo(forceReload: forceReload)
            .formatInfo()
            .mapToState()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchAllLaunches(criteria: FilterCriteria = DefaultFilterCriteria.noFilter, order: ComparisonResult, forceReload: Bool = false) -> AnyPublisher<ContentState<[LaunchModel]>, Never> {
        return dataSource
            .fetchAllLaunches(forceReload: forceReload)
            .mapToModel()
            .onlyMatching(criteria: criteria)
            .sort(order: order)
            .mapToState()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - "Company Info" stream operators
extension Publisher where Output == CompanyInfo, Failure == DataSourceError {
    
    func formatInfo() -> AnyPublisher<String, Failure> {
        return self
            .map({ companyInfo -> String in
                
                let creator = LaunchModelCreator()
                let result = creator.createCompanyInfo(companyInfo)
                
                return result
        }).eraseToAnyPublisher()
    }
}

extension Publisher where Output == String, Failure == DataSourceError {
    
    func mapToState() -> AnyPublisher<ContentState<String>, Never> {
        return self
            .map { .loaded($0) }
            .catch { Just(ContentState.error($0)) }
            .eraseToAnyPublisher()
    }
}

// MARK: - "All Launches" stream operators
extension Publisher where Output == [LaunchModel], Failure == DataSourceError {
    
    func onlyMatching(criteria: FilterCriteria = DefaultFilterCriteria.noFilter) -> AnyPublisher<[LaunchModel], Failure> {
        return self
            .map { $0.onlyMatching(criteria) }
            .eraseToAnyPublisher()
    }
    
    func sort(order: ComparisonResult) -> AnyPublisher<[LaunchModel], Failure> {
        return self
            .map { $0.sortedByDate(order: order) }
            .eraseToAnyPublisher()
    }
    
    func mapToState() -> AnyPublisher<ContentState<[LaunchModel]>, Never> {
        return self
            .map { $0.count > 0 ? .loaded($0) : .empty }
            .catch { Just(ContentState.error($0)) }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == [LaunchInfo], Failure == DataSourceError {
    
    func mapToModel() -> AnyPublisher<[LaunchModel], Failure> {
        return self
            .map { $0.createViewModel() }
            .eraseToAnyPublisher()
    }
    

}

extension Array where Element == LaunchInfo {
    
    func createViewModel(referenceDate: Date = Date(), locale: Locale = Locale.current) -> [LaunchModel] {
        
        let creator = LaunchModelCreator(referenceDate: referenceDate, locale: locale)
        let result = creator.createModelsFrom(launchInfo: self)
        return result

    }
}
