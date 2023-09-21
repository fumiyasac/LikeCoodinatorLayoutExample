//
//  ContentHeaderView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/14.
//

import SwiftUI

struct ContentHeaderView: View {

    // MARK: - Property (Initializer)

    let selectedBreadList: BreadList
    let shouldCollapse: Bool
    let onTapHeaderButton: (BreadList) -> Void

    // MARK: - Property (Private)

    // 配置対象のButton要素下に配置する矩形要素位置を調整するために必要な定数値
    private let buttonAreaLeadingMargin = 16.0
    private let buttonTrailingMargin = 16.0
    private let betweenButtonMargin = 8.0

    // 配置対象のButton総数
    // 👉 今回は「Enum定義の総数」と等しくなる様な形にしています。
    private var buttonsCount: Int {
        BreadList.allCases.count
    }

    // MARK: - Body

    var body: some View {
        // View全体を覆うZStack要素
        ZStack {
            // 1. 要素全体の背景色
            Color.white
            // 2. 横一列に並ぶButton要素
            HStack(spacing: 8.0) {
                // Enum定義を元に要素数分のボタン要素を配置する
                ForEach(BreadList.allCases, id: \.rawValue) { breadList in
                    Button {
                        // おおもとのView要素側でどのボタンがタップされたかを識別するために、Closureを介して該当するEnum値を渡す
                        onTapHeaderButton(breadList)
                    } label: {
                        VStack(spacing: 0.0) {
                            Text(breadList.subtitle)
                                .font(.system(size: 12.0, weight: .bold, design: .rounded))
                            // Header要素を折りたたむ場合はメインタイトル表示部分を非表示にする
                            if !shouldCollapse {
                                Text(breadList.title)
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .frame(height: 32.0)
                            }
                        }
                        // MEMO: ContentView側に配置した要素の幅設定の影響を受けやすいので注意
                        .frame(maxWidth: .infinity)
                        // MEMO: 引数から渡された`selectedBreadList(Enum値)`や`shouldCollapse`を利用して配色や余白に関する微調整を実施
                        .padding(shouldCollapse ? 6.0 : 4.0)
                        .foregroundStyle(selectedBreadList == breadList ? .white : .primary)
                    }
                }
            }
            // MEMO: .backgroundと.paddingの順番がこの形でないと崩れてしまうので注意
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .background(alignment: .center) {
                // Button背景要素に対してGeometryReaderを利用し、選択されているボタンに応じた矩形表示部分のAnimation処理を実行する
                // 👉 Button要素に直接背景を付与するのではなく、Button要素配置エリアとAnimationを伴う背景エリアを分割しています。
                // 👉 GeometryReaderから取得できる`geometry.size.width`は回転した際は値が変化するので、回転時は再度計算処理が実行されます。
                GeometryReader { geometry in
                    // 今回のAnimation処理のポイントとなるのは、選択されているボタンによってX軸方向のOffset値を変更する処理を適用する部分
                    Capsule()
                        .fill(Color(uiColor: UIColor(code: "#bfa46f")))
                        .frame(
                            width: calculateButtonWidth(deviceWidth: geometry.size.width),
                            height: calculateButtonHeight()
                        )
                        .offset(x: calculateDynamicTabHorizontalOffset(deviceWidth: geometry.size.width), y: 10.0)
                        .animation(.easeInOut(duration: 0.16), value: selectedBreadList)
                }
            }
        }
        // 引数から渡された`shouldCollapse`の値を利用して、Header要素全体の高さをAnimation付きで変更する
        .frame(height: shouldCollapse ? 53.0 : 82.0)
        .animation(.easeInOut(duration: 0.08), value: shouldCollapse)
    }

    // MEMO: 引数から渡された`selectedBreadList(Enum値)`を利用して、Button背景要素のX軸方向のOffset値を算出する
    private func calculateDynamicTabHorizontalOffset(deviceWidth: CGFloat) -> CGFloat {
        let buttonAreaWidth = calculateButtonWidth(deviceWidth: deviceWidth)
        // Button要素1つ分の幅に加えて、Enumに応じたIndex値やMargin値も活用することで、表示位置をできるだけ正確に合わせる
        let indexBySelectedBreadList = getIndexBySelectedBreadList()
        return buttonAreaLeadingMargin + (betweenButtonMargin + buttonAreaWidth) * CGFloat(indexBySelectedBreadList)
    }

    // 引数から渡された`shouldCollapse`の値を利用して、Button要素に付与する高さを算出する
    private func calculateButtonHeight() -> CGFloat {
        return shouldCollapse ? CGFloat(32.0) : CGFloat(56.0)
    }

    // Enumに応じたIndex値を定義し、X軸方向の停止位置算出のために活用する
    private func getIndexBySelectedBreadList() -> Int {
        switch selectedBreadList {
        case .first:
            0
        case .second:
            1
        case.third:
            2
        }
    }

    // Button要素1つ分の幅を取得する
    private func calculateButtonWidth(deviceWidth: CGFloat) -> CGFloat {
        // 計算式: Button要素1つ分の幅 = (GeometryProxyから取得した幅 - Button要素間Margin値の総和) / Button総数
        let excludeTotalMargin = calculateExcludeTotalMargin()
        return (deviceWidth - excludeTotalMargin) / CGFloat(buttonsCount)
    }

    // 配置したButton要素間Margin値の総和を取得する
    private func calculateExcludeTotalMargin() -> CGFloat {
        let totalBetweenButtonMargin = betweenButtonMargin * CGFloat(buttonsCount - 1)
        return buttonAreaLeadingMargin + buttonTrailingMargin + totalBetweenButtonMargin
    }
}
