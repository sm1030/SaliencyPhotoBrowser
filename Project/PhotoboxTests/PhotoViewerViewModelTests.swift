//
//  PhotoViewerViewModelTests.swift
//  PhotoboxTests
//
//  Created by Alexandre Malkov on 01/10/2022.
//

import XCTest
@testable import Photobox
import SwiftUI
import Photos

class PhotoViewerViewModelTests: XCTestCase {
    
    let w100h200size = CGSize(width: 100, height: 200)
    let w100h400size = CGSize(width: 100, height: 400)
    let w200h100size = CGSize(width: 200, height: 100)
    let w400h100size = CGSize(width: 400, height: 100)
    
    var photoViewerViewModel: PhotoViewerViewModel!

    @MainActor override func setUpWithError() throws {
        photoViewerViewModel = PhotoViewerViewModel(asset: PHAsset(), targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill)
    }

    @MainActor func testImageFameSizeWithAspectFill() throws {
        photoViewerViewModel.isAspectFill = true
        
        var frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w100h200size, imageSize: w100h400size)
        XCTAssertEqual(frameSize.width, 100)
        XCTAssertEqual(frameSize.height, 400)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w100h200size, imageSize: w400h100size)
        XCTAssertEqual(frameSize.width, 800)
        XCTAssertEqual(frameSize.height, 200)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w200h100size, imageSize: w100h400size)
        XCTAssertEqual(frameSize.width, 200)
        XCTAssertEqual(frameSize.height, 800)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w200h100size, imageSize: w400h100size)
        XCTAssertEqual(frameSize.width, 400)
        XCTAssertEqual(frameSize.height, 100)
    }
    
    @MainActor func testImageFameSizeWithAspectFit() throws {
        photoViewerViewModel.isAspectFill = false
        
        var frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w100h200size, imageSize: w100h400size)
        XCTAssertEqual(frameSize.width, 50)
        XCTAssertEqual(frameSize.height, 200)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w100h200size, imageSize: w400h100size)
        XCTAssertEqual(frameSize.width, 100)
        XCTAssertEqual(frameSize.height, 25)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w200h100size, imageSize: w100h400size)
        XCTAssertEqual(frameSize.width, 25)
        XCTAssertEqual(frameSize.height, 100)
        
        frameSize = photoViewerViewModel.imageFrameSize(geometrySize: w200h100size, imageSize: w400h100size)
        XCTAssertEqual(frameSize.width, 200)
        XCTAssertEqual(frameSize.height, 50)
    }
}
