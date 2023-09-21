//
//  ContentHeaderView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/14.
//

import SwiftUI

struct ContentHeaderView: View {

    let selectedBreadList: BreadList
    let shouldCollapse: Bool
    let onTapButton: (BreadList) -> Void

    // Define margin values to calculate horizontal position for capsule rectangle
    private let buttonAreaLeadingMargin = 16.0
    private let buttonTrailingMargin = 16.0
    private let betweenButtonMargin = 8.0

    // Define all button count to calculate horizontal position for capsule rectangle
    private var buttonsCount: Int {
        BreadList.allCases.count
    }

    var body: some View {
        ZStack {
            Color.white
            HStack(spacing: 8.0) {
                ForEach(BreadList.allCases, id: \.rawValue) { breadList in
                    Button {
                        onTapButton(breadList)
                    } label: {
                        VStack(spacing: 0) {
                            Text(breadList.subtitle)
                                .font(.system(size: 12.0, weight: .bold, design: .rounded))
                            if !shouldCollapse {
                                Text(breadList.title)
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .frame(height: 32.0)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(shouldCollapse ? 6.0 : 4.0)
                        .foregroundStyle(selectedBreadList == breadList ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .background(alignment: .center) {
                GeometryReader { geometry in
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
        .frame(height: shouldCollapse ? 53.0 : 82.0)
        .animation(.easeInOut(duration: 0.08), value: shouldCollapse)
    }

    private func calculateDynamicTabHorizontalOffset(deviceWidth: CGFloat) -> CGFloat {
        let buttonAreaWidth = calculateButtonWidth(deviceWidth: deviceWidth)
        // Get the index value corresponding to `selectedDay` and use it for calculation
        let indexBySelectedDay = getIndexBySelectedDay()
        return buttonAreaLeadingMargin + (betweenButtonMargin + buttonAreaWidth) * CGFloat(indexBySelectedDay)
    }

    private func calculateButtonHeight() -> CGFloat {
        return shouldCollapse ? CGFloat(32) : CGFloat(56)
    }

    private func getIndexBySelectedDay() -> Int {
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
        // Calculate button width considering related margins
        let excludeTotalMargin = calculateExcludeTotalMargin()
        return (deviceWidth - excludeTotalMargin) / CGFloat(buttonsCount)
    }

    private func calculateExcludeTotalMargin() -> CGFloat {
        let totalBetweenButtonMargin = betweenButtonMargin * CGFloat(buttonsCount - 1)
        return buttonAreaLeadingMargin + buttonTrailingMargin + totalBetweenButtonMargin
    }
}

//struct ContentHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentHeaderView()
//    }
//}
