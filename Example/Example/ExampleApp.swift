//
//  ExampleApp.swift
//  Example
//
//  Created by Mitsuharu Emoto on 2023/08/26.
//

import SwiftUI

let appStore = makeAppStore()

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
