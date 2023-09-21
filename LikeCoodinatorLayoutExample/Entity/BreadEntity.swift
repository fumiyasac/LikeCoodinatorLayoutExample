//
//  BreadEntity.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/16.
//

import Foundation

struct BreadEntity: Hashable {

    // MARK: - Property

    let id: String
    let name: String
    let summary: String
    let imageName: String

    // MARK: - Initializer

    init(
        name: String,
        summary: String,
        imageName: String
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.summary = summary
        self.imageName = imageName
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BreadEntity, rhs: BreadEntity) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.summary == rhs.summary
            && lhs.imageName == rhs.imageName
    }
}
