//
//  ContentViewModel.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/16.
//

import Foundation

enum BreadList {
    case day1
    case day2
    case day3
}

@MainActor
final class ContentViewModel: ObservableObject {

    //
    @Published private(set) var selectedBreadList: BreadList = .day1
    
}
