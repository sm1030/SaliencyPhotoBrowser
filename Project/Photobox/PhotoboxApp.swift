//
//  PhotoboxApp.swift
//  Photobox
//
//  Created by Alexandre Malkov on 29/09/2022.
//

import SwiftUI

@main
struct PhotoboxApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = ContentViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
