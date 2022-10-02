//
//  PhotoViewerViewModel.swift
//  Photobox
//
//  Created by Alexandre Malkov on 01/10/2022.
//

import UIKit
import Photos
import Vision

@MainActor final class PhotoViewerViewModel: ObservableObject {
    
    let asset: PHAsset
    let targetSize: CGSize
    let contentMode: PHImageContentMode
    
    @Published var image: UIImage?
    @Published var isAspectFill = false
    @Published var saliencyRegion: CGRect?
    
    init(asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) {
        self.asset = asset
        self.targetSize = targetSize
        self.contentMode = contentMode
    }
    
    func loadImage() {
        Task {
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: nil) { [weak self] image, info in
                self?.image = image
                self?.findSaliencyRegion()
            }
        }
    }
    
    func imageFrameSize(geometrySize: CGSize, imageSize: CGSize) -> CGSize {
        let imageAspectRatio = imageSize.height / imageSize.width
        let geometryAspectRatio = geometrySize.height / geometrySize.width
        
        if isAspectFill {
            if imageAspectRatio > geometryAspectRatio {
                return CGSize(width: geometrySize.width,
                              height: geometrySize.width * imageAspectRatio)
            } else {
                return CGSize(width: geometrySize.height / imageAspectRatio,
                              height: geometrySize.height)
            }
        } else {
            if imageAspectRatio > geometryAspectRatio {
                return( CGSize(width: geometrySize.height / imageAspectRatio,
                               height: geometrySize.height))
            } else {
                return( CGSize(width: geometrySize.width,
                               height: geometrySize.width * imageAspectRatio))
            }
        }
    }
    
    func findSaliencyRegion() {
        Task {
            do {
                guard let image = image,
                      let originalImage = image.cgImage else {
                    return
                }
                let requestHandler = VNImageRequestHandler(cgImage: originalImage, options: [:])
                let saliencyRequest = VNGenerateAttentionBasedSaliencyImageRequest { vnRequest, error in
                    guard let observation = (vnRequest.results?.first as? VNSaliencyImageObservation)?.salientObjects?.first as? VNRectangleObservation else {
                        return
                    }

                    self.saliencyRegion = CGRect(x: observation.bottomLeft.x,
                                            y: observation.bottomLeft.y,
                                            width: observation.topRight.x - observation.bottomLeft.x,
                                            height: observation.topRight.y - observation.bottomLeft.y)
                }
                try requestHandler.perform([saliencyRequest])
            } catch {
                print(error)
            }
        }
    }
}

