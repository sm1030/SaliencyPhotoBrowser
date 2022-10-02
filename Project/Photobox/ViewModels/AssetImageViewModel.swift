//
//  AssetImageViewModel.swift
//  Photobox
//
//  Created by Alexandre Malkov on 29/09/2022.
//

import UIKit
import Photos

@MainActor final class AssetImageViewModel: ObservableObject {
    
let asset: PHAsset
let targetSize: CGSize
let contentMode: PHImageContentMode
    
    @Published var image: UIImage?
    
    init(asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) {
        self.asset = asset
        self.targetSize = targetSize
        self.contentMode = contentMode
        loadImage()
    }
    
    func loadImage() {
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: nil) { [weak self] image, info in
            self?.image = image
        }
    }
}
