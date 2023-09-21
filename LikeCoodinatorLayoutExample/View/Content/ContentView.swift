//
//  ContentView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/12.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Property (Private)

    // Y軸方向のOffset値がこの値を超過したら「変数: shouldCollapse」を変更する
    private let verticalOffsetThreshold = -192.0

    // Header要素を折りたたむか否かを判定するフラグ値を設定する
    // 👉 LazyVStack内に配置した「要素: ContentHeaderView」の状態変更をするために利用する
    @State private var shouldCollapse = false

    // MARK: - Property (ViewModel)

    // 画面表示用に使用するViewModel
    // 👉 内部の`@Published private(set) var 変数名`で定義したものを画面要素表示に利用する
    @StateObject private var viewModel: ContentViewModel = .init()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            // View全体を覆うZStack要素
            // 👉 ScrollViewで表示する一覧表示部分の後ろ側にサムネイル画像を重ねて表示するためこの形にしています。
            ZStack(alignment: .topLeading) {
                // 1. ScrollView要素の背後に表示する要素
                // ※画像の上に透明なRectangle要素を重ねて表示する様なイメージです。
                ZStack(alignment: .top) {
                    // 1-(1). サムネイル用画像表示
                    Image("background")
                        .resizable()
                        .clipped()
                        .frame(height: 360.0)
                    // 1-(2). レクタングル要素表示
                    Rectangle()
                        .fill(Color(uiColor: UIColor(code: "#bfa46f")).opacity(0.48))
                        .frame(height: 360.0)
                }
                // 2. 表示データ一覧を配置するためのScrollView要素
                ScrollViewWithVerticalOffset(
                    // Y軸方向のOffset値が更新された際に実行する処理部分
                    // ※擬似的ではありますが、UIKitで言うところのUIScrollViewDelegateで提供されている`scrollViewDidScroll(_:)`と類似した形となります。
                    onOffsetChange: { offset in
                        // 取得したY軸方向のOffset値がしきい値を超過するか否かを見て、Header要素の状態を決定する
                        shouldCollapse = offset < verticalOffsetThreshold
                    },
                    // ScrollView要素内に配置する要素を定義する部分
                    content: {
                        // ScrollView内に配置した要素を下方向へずらすためにSpacer要素
                        // 👉 ScrollViewで表示する一覧表示部分の後ろ側にサムネイル画像を重ねて表示するためこの形にしています。
                        Spacer()
                            .frame(height: 180.0)
                        // ScrollView内に配置したデータ一覧表示をする部分
                        // 👉 pinnedViewsの設定で上方向にスクロールした際にHeader要素が吸い付く様な感じの表現が可能です。
                        LazyVStack(spacing: 0.0, pinnedViews: .sectionHeaders) {
                            // Sectionを利用してHeader付き一覧表示として取り扱う点がポイント
                            Section(
                                // 1. Content要素定義部分
                                content: {
                                    // ForEachを利用してViewModelから取得したデータを一覧表示する
                                    VStack(spacing: 0.0) {
                                        ForEach(viewModel.selectedBreadEntities, id: \.id) { selectedBreadEntity in
                                            ContentRowView(breadEntity: selectedBreadEntity)
                                        }
                                    }
                                    .padding(.bottom, 24.0)
                                },
                                // 2. Header要素定義部分
                                header: {
                                    // スクロール変化量と連動して高さと表示が変化するHeader要素を表示する
                                    // 👉 Header要素に適用するAnimation処理のために必要な値を適用しています。
                                    // (1) selectedBreadList: Header内部のボタンに関するAnimation処理で利用します。
                                    // (2) shouldCollapse: Headerの高さ変更に関するAnimation処理で利用します。
                                    // 👉 Header内のボタンクリック処理時にViewModel側の処理を実施するためにClosureを利用しています。
                                    ContentHeaderView(
                                        selectedBreadList: viewModel.selectedBreadList,
                                        shouldCollapse: shouldCollapse,
                                        onTapHeaderButton: { [weak viewModel] breadList in
                                            // Header要素内のボタンクリックと連動したViewModel側に定義した表示変更処理を実行する
                                            viewModel?.selectBreadList(breadList: breadList)
                                        }
                                    )
                                }
                            )
                        }
                        .background(.white)
                    }
                )
                // Navigation表示に関する設定
                .navigationTitle("Bread List Example")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
