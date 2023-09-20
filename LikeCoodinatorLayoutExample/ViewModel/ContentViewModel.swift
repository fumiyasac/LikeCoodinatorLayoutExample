//
//  ContentViewModel.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/16.
//

import Foundation

enum BreadList {
    case first
    case second
    case third
}

@MainActor
final class ContentViewModel: ObservableObject {

    //
    @Published private(set) var selectedBreadList: BreadList = .first
}
