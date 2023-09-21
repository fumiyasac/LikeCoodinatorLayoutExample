//
//  LikeCoodinatorLayoutExampleApp.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/12.
//

import SwiftUI

@main
struct LikeCoodinatorLayoutExampleApp: App {

    // MARK: - Property (@UIApplicationDelegateAdaptor)

    // MEMO: AppDelegate部分を切り出しています（※NavigationBarの配色変更で利用しています）
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
