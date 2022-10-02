//
//  PhotoViewerView.swift
//  Photobox
//
//  Created by Alexandre Malkov on 01/10/2022.
//

import SwiftUI
import Photos

struct PhotoViewerView: View {
    
    @EnvironmentObject var viewModel: PhotoViewerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Page background
            Color.black
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // Back button
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                           
                    Spacer()
                           
                    // Zoom button
                    Button {
                        viewModel.isAspectFill.toggle()
                    } label: {
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                if let image = viewModel.image {
                    GeometryReader { geometry in
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            let imageFrameSize = viewModel.imageFrameSize(geometrySize: geometry.size, imageSize: image.size)
                            // Resizable image
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: imageFrameSize.width, height: imageFrameSize.height)
                                .overlay(alignment: .topLeading) {
                                    
                                    // Saliency rectangle
                                    if let saliencyRegion = viewModel.saliencyRegion {
                                        Color.clear
                                            .border(.red, width: 3)
                                            .offset(x: saliencyRegion.origin.x * imageFrameSize.width,
                                                    y: saliencyRegion.origin.y * imageFrameSize.height)
                                            .frame(width: saliencyRegion.size.width * imageFrameSize.width,
                                                   height: saliencyRegion.size.height * imageFrameSize.height)
                                    }
                                }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            viewModel.loadImage()
        }
        .onDisappear {
            viewModel.isAspectFill = false
        }
        .navigationBarHidden(true)
        .animation(.linear(duration: 0.2), value: viewModel.isAspectFill)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhotoViewerViewModel(asset: PHAsset(),
                                             targetSize: CGSize(width: 200, height: 200),
                                             contentMode: .aspectFill)
        PhotoViewerView()
            .environmentObject(viewModel)
    }
}
