//
//  ContentView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/12.
//

import SwiftUI

struct ContentView: View {

    // MARK: - property

    //
    private let verticalOffsetThreshold = -142.0

    //
    @State private var shouldCollapse = false

    // MARK: - body

    var body: some View {
        NavigationStack {
            //
            ZStack(alignment: .topLeading) {
                //
                ZStack(alignment: .top) {
                    //
                }
                //
                ScrollViewWithVerticalOffset(
                    //
                    onOffsetChange: { offset in
                        //
                        shouldCollapse = offset < verticalOffsetThreshold
                    },
                    //
                    content: {
                        //
                        Spacer()
                            .frame(height: 130.0)
                        //
//                        LazyVStack(spacing: 0.0, pinnedViews: .sectionHeaders) {
//                            Section(
//                                header:
//                                    ContentHeaderView()
//                                )
//                                .frame(height: shouldCollapse ? 53.0 : 82.0)
//                                .animation(.easeInOut(duration: 0.08), value: shouldCollapse)
//                            ) {
//                                //
//                                ContentRowView()
//                            }
//                        }
//                        .background(.white)
                    }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
