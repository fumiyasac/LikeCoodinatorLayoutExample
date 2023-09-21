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
    private let verticalOffsetThreshold = -192.0

    //
    @State private var shouldCollapse = false

    //
    @StateObject private var viewModel: ContentViewModel = .init()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            //
            ZStack(alignment: .topLeading) {
                //
                ZStack(alignment: .top) {
                    //
                    Image("background")
                        .resizable()
                        //.scaledToFill()
                        .clipped()
                        .frame(height: 360.0)
                    Rectangle()
                        .fill(
                            Color(uiColor: UIColor(code: "#bfa46f"))
                                .opacity(0.48)
                        )
                        .frame(height: 360.0)
                    
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
                            .frame(height: 180.0)
                        //
                        LazyVStack(spacing: 0.0, pinnedViews: .sectionHeaders) {
                            //
                            Section(
                                content: {
                                    //
                                    VStack(spacing: 0) {
                                        ForEach(0..<48) { _ in
                                            ContentRowView()
                                         }
                                    }
                                    .padding(.vertical, 24)
                                },
                                header: {
                                    ContentHeaderView(
                                        selectedBreadList: viewModel.selectedBreadList,
                                        shouldCollapse: shouldCollapse,
                                        onTapButton: { [weak viewModel] breadList in
                                            viewModel?.selectBreadList(breadList: breadList)
                                        }
                                    )
                                }
                            )
                        }
                        .background(.white)
                    }
                )
                //
                .navigationTitle("Bread List Example")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
