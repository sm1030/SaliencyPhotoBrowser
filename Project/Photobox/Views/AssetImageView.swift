//
//  AssetImageView.swift
//  Photobox
//
//  Created by Alexandre Malkov on 29/09/2022.
//

import SwiftUI

struct AssetImageView: View {
    
    let sideSize: CGFloat?
    
    @EnvironmentObject var viewModel: AssetImageViewModel
    
    var body: some View {
        if let sideSize = sideSize {
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                } else {
                    ProgressView()
                }
            }
            .frame(width: sideSize, height: sideSize)
            .clipped()
        } else {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
    }
}

struct AssetImageView_Previews: PreviewProvider {
    static var previews: some View {
        AssetImageView(sideSize: 50)
    }
}
