//
//  LikeCoodinatorLayoutExampleApp.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/12.
//

import SwiftUI

@main
struct LikeCoodinatorLayoutExampleApp: App {

    // MARK: - property

    // MEMO: AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
