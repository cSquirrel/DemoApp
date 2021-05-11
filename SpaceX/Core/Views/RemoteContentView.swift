//
//  CompanyInfoView.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import SwiftUI
import Combine

struct EmptyView: View {
    
    var body: some View {
        Text("no data received")
    }
}

struct ErrorView: View {
    var body: some View {
        Text("error while fetching data")
    }
}

struct RemoteContentView<Content: View, Value: Any>: View {
    
    @Binding var state: ContentState<Value>
    @ViewBuilder var contentView: (Value) -> Content
    
    var body: some View {
        switch state {
        case .fetching:
            Text("fetching data from the internet")
                .redacted(reason: .placeholder)
        case .loaded(let data):
            contentView(data)
        case .empty:
            EmptyView()
        case .error:
            ErrorView()
        }
    }
}
