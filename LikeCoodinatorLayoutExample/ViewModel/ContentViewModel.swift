//
//  ContentViewModel.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/16.
//

import Foundation

enum BreadList: String, CaseIterable {
    case first
    case second
    case third

    var title: String {
        switch self {
        case .first:
            "1番目"
        case .second:
            "2番目"
        case .third:
            "3番目"
        }
    }

    var subtitle: String {
        switch self {
        case .first:
            "🍞first"
        case .second:
            "🥐second"
        case .third:
            "🍩third"
        }
    }
}

@MainActor
final class ContentViewModel: ObservableObject {

    // MARK: - Property

    //
    @Published private(set) var selectedBreadList: BreadList = .first
    @Published private(set) var selectedBreadEntities: [BreadEntity] = []

    // MARK: - Initializer

    init() {
        makeSelectedBreadEntities(breadList: .first)
    }

    // MARK: - Function

    func selectBreadList(breadList: BreadList) {
        selectedBreadList = breadList
        makeSelectedBreadEntities(breadList: breadList)
    }

    // MARK: - Private Function

    private func makeSelectedBreadEntities(breadList: BreadList) {

        //
        selectedBreadEntities = (1...16).map { index in
            BreadEntity(
                name: "美味しいパン[\(breadList.title)のサンプルNo.\(index)]",
                summary: "こちらは「美味しいパン[\(breadList.title)のサンプルNo.\(index)]」の説明文言サンプルになります。\n美味しいパンとコーヒーの組み合わせは、朝の目覚めと「よし！今日も1日頑張っていこう！」という気持ちを奮い立たせる最高の組み合わせであると考えています。",
                imageName: "sample_\(breadList.rawValue)_\(String(format: "%02d", index))"
            )
        }
    }
}
