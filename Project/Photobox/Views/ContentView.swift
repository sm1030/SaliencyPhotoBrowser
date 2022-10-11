//
//  ContentView.swift
//  Photobox
//
//  Created by Alexandre Malkov on 29/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    let itemSideSize = UIScreen.main.bounds.size.width / 4 - 6
    let photoViewerImageSideSize = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.displayP3, red: 0.969, green: 0.969, blue: 0.969, opacity: 1)
                    .ignoresSafeArea()
                
                ScrollView {
                    let columns = [
                        GridItem(.adaptive(minimum: itemSideSize))
                    ]
                    
                    LazyVGrid(columns: columns, alignment: .center, spacing: 6) {
                        if viewModel.photosCount > 0 {
                            // Why do I use photosCount range approach instead of creating and itterating assets collection?
                            // Because I'm using PHFetchResult and this way will let me to present grid before all assets was loaded.
                            ForEach((0...viewModel.photosCount-1), id: \.self) { assetId in
                                let asset = viewModel.allPhotosFetchResult[assetId]
                                NavigationLink {
                                    let photoViewerViewModel = PhotoViewerViewModel(asset: asset,
                                                                                    targetSize: CGSize(
                                                                                        width: photoViewerImageSideSize,
                                                                                        height: photoViewerImageSideSize),
                                                                                    contentMode: .aspectFill)
                                    PhotoViewerView()
                                        .environmentObject(photoViewerViewModel)
                                } label: {
                                    let assetImageViewModel = AssetImageViewModel(asset: asset,
                                                                                  targetSize: CGSize(
                                                                                    width: itemSideSize,
                                                                                    height: itemSideSize),
                                                                                  contentMode: .aspectFit)
                                    AssetImageView(sideSize: itemSideSize)
                                        .environmentObject(assetImageViewModel)
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Recents"), displayMode: .inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContentViewModel()
        ContentView()
            .environmentObject(viewModel)
    }
}
