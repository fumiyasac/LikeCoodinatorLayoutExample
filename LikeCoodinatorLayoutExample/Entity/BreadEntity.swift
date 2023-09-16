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
    let category: String
    let imageName: String
    let selectedDay: String

    // MARK: - Initializer

    init(
        name: String,
        summary: String,
        category: String,
        imageName: String,
        selectedDay: String
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.summary = summary
        self.category = category
        self.imageName = imageName
        self.selectedDay = selectedDay
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BreadEntity, rhs: BreadEntity) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.summary == rhs.summary
            && lhs.category == rhs.category
            && lhs.imageName == rhs.imageName
            && lhs.selectedDay == rhs.selectedDay
    }
}
