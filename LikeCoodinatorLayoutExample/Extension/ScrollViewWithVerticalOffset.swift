//
//  ScrollViewWithVerticalOffset.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/17.
//

import SwiftUI

// MEMO: ScrollViewそのままではY軸方向のOffsetを取得する事ができない
// 👉 PreferenceKeyを利用して変化を監視する ＆ GeometryReaderの中にColor.clearを入れて"frameLayer"を値を取る様な形とする
// 参考: 下記のコードを参考にしています
// https://gist.github.com/Kievkao/0682dc8814a953640ca9b74413424bb8

struct ScrollViewWithVerticalOffset<Content: View>: View {

    // MARK: - Property

    let onOffsetChange: (CGFloat) -> Void
    let content: () -> Content

    // MARK: - Initializer

    init(
        onOffsetChange: @escaping (CGFloat) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onOffsetChange = onOffsetChange
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical) {
            offsetReader
            content()
                .padding(.top, 0)
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }

    // MARK: - Private Function

    private var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
}

// MARK: - Private Struct

private struct OffsetPreferenceKey: PreferenceKey {

    // MARK: - Property

    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
