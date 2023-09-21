//
//  ScrollViewWithVerticalOffset.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/17.
//

import SwiftUI

// MEMO: ScrollViewそのままではY軸方向のOffsetを取得する事ができない
// 👉 PreferenceKeyを利用して変化を監視する ＆ GeometryReaderの中にColor.clearを入れて"frameLayer"を値を取る様な形をとっています
// 参考: 下記のコードを参考にしています
// https://gist.github.com/Kievkao/0682dc8814a953640ca9b74413424bb8

struct ScrollViewWithVerticalOffset<Content: View>: View {

    // MARK: - Property (Initializer)

    let onOffsetChange: (CGFloat) -> Void
    let content: () -> Content

    // MARK: - Property (Private)

    // GeometryReaderで利用する座標空間を識別するための独自の名前
    private let coordinateSpaceName = "frameLayer"

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
                .padding(.top, 0.0)
        }
        // 座標空間に独自の名前を付与する
        .coordinateSpace(name: coordinateSpaceName)
        // OffsetPreferenceKeyで設定した監視対象の値が変化した場合はその値をClosureで受け取れる様な形にする
        // 👉 この様な形にすることで、変化するたびにY軸方向のOffset値の変化を取得できる様になります。
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }

    // MARK: - Private Function

    private var offsetReader: some View {
        // GeometryReader内部にはColorを定義してScrollView内に配置する要素には極力影響を及ぼさない様にする
        GeometryReader { proxy in
            Color.clear
                // OffsetPreferenceKey定義とGeometryProxyから取得できる値を紐づける事でこの値変化を監視対象に設定する
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named(coordinateSpaceName)).minY
                )
        }
        .frame(height: 0.0)
    }
}

// MARK: - Private Struct

private struct OffsetPreferenceKey: PreferenceKey {

    // MARK: - Property

    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
