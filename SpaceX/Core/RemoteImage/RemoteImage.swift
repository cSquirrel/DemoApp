//
//  RemoteImage.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 06/05/2021.
//

import SwiftUI
import Combine

struct RemoteImage: View {

    @ObservedObject private var loader: RemoteImageLoader
    
    let placeholder: Image
    let failure: Image

    var body: some View {
        fetchImage()
            .resizable()
    }

    init(loader: RemoteImageLoader,
         placeholder: Image = Image(systemName: "photo"),
         failure: Image = Image(systemName: "exclamationmark.square")) {
        
        self.loader = loader
        self.placeholder = placeholder
        self.failure = failure
        
    }

    private func fetchImage() -> Image {
        switch loader.state {
        case .loading:
            return placeholder
        case .failure:
            return failure
        case .success(let data):
            if let image = UIImage(data: data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
