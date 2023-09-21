//
//  ContentHeaderView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/14.
//

import SwiftUI

struct ContentHeaderView: View {

    // MARK: - Property

    let selectedBreadList: BreadList
    let shouldCollapse: Bool
    let onTapHeaderButton: (BreadList) -> Void

    //
    private let buttonAreaLeadingMargin = 16.0
    private let buttonTrailingMargin = 16.0
    private let betweenButtonMargin = 8.0

    //
    private var buttonsCount: Int {
        BreadList.allCases.count
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.white
            HStack(spacing: 8.0) {
                //
                ForEach(BreadList.allCases, id: \.rawValue) { breadList in
                    Button {
                        //
                        onTapHeaderButton(breadList)
                    } label: {
                        //
                        VStack(spacing: 0.0) {
                            Text(breadList.subtitle)
                                .font(.system(size: 12.0, weight: .bold, design: .rounded))
                            //
                            if !shouldCollapse {
                                Text(breadList.title)
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .frame(height: 32.0)
                            }
                        }
                        //
                        .frame(maxWidth: .infinity)
                        .padding(shouldCollapse ? 6.0 : 4.0)
                        .foregroundStyle(selectedBreadList == breadList ? .white : .primary)
                    }
                }
            }
            // MEMO: .backgroundと.paddingの順番がこの形でないと崩れてしまうので注意
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .background(alignment: .center) {
                GeometryReader { geometry in
                    //
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
        //
        .frame(height: shouldCollapse ? 53.0 : 82.0)
        .animation(.easeInOut(duration: 0.08), value: shouldCollapse)
    }

    private func calculateDynamicTabHorizontalOffset(deviceWidth: CGFloat) -> CGFloat {
        let buttonAreaWidth = calculateButtonWidth(deviceWidth: deviceWidth)
        //
        let indexBySelectedBreadList = getIndexBySelectedBreadList()
        return buttonAreaLeadingMargin + (betweenButtonMargin + buttonAreaWidth) * CGFloat(indexBySelectedBreadList)
    }

    private func calculateButtonHeight() -> CGFloat {
        return shouldCollapse ? CGFloat(32.0) : CGFloat(56.0)
    }

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

    private func calculateButtonWidth(deviceWidth: CGFloat) -> CGFloat {
        //
        let excludeTotalMargin = calculateExcludeTotalMargin()
        return (deviceWidth - excludeTotalMargin) / CGFloat(buttonsCount)
    }

    private func calculateExcludeTotalMargin() -> CGFloat {
        let totalBetweenButtonMargin = betweenButtonMargin * CGFloat(buttonsCount - 1)
        return buttonAreaLeadingMargin + buttonTrailingMargin + totalBetweenButtonMargin
    }
}
