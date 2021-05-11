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

struct RemoteContentView_Previews: PreviewProvider {

    @State static var loadedState = ContentState<String>.loaded("Loaded Value")
    @State static var errorState = ContentState<String>.error(DataSourceError.generalError)
    @State static var emptyState = ContentState<String>.empty

    static var previews: some View {
        VStack(spacing: 24) {
            
            RemoteContentView<Text, String>(state: $loadedState) { value in
                Text("Loaded Value: \(value)")
            }
            .padding()
            .border(Color.black)
            
            RemoteContentView<Text, String>(state: $errorState) { _ in
                Text("")
            }
            .padding()
            .border(Color.black)

            RemoteContentView<Text, String>(state: $emptyState) { _ in
                Text("")
            }
            .padding()
            .border(Color.black)
        }
    }
}
