//
//  ContentViewModel.swift
//  Photobox
//
//  Created by Alexandre Malkov on 29/09/2022.
//

import Foundation
import Photos

@MainActor final class ContentViewModel: ObservableObject {
    
    @Published var photosCount: Int = 0
    
    var allPhotosFetchResult: PHFetchResult<PHAsset>!
    
    init() {
        getPhotoAssets()
    }
    
    func getPhotoAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosFetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        photosCount = min(allPhotosFetchResult.count, 1000)
        
        // This looks ugly, but I could not come up with better way of detecting when user grants permission to access photos on the device
        // So, instead I will try to get photo assets each second untill I get some photo assets
        if photosCount == 0 {
            Task {
                // Delay the task by 1 second:
                try await Task.sleep(nanoseconds: 1_000_000_000)
                getPhotoAssets()
            }
        }
    }
}

