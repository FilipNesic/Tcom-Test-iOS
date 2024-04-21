//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI

@main
struct TaskAppApp: App {
    let loginViewModel = DataProviderModel()
    
    var body: some Scene {
        WindowGroup {
            if !loginViewModel.savedToken.isEmpty {
                MainRootView()
            } else {
                LoginView()
            }
        }
    }
}
