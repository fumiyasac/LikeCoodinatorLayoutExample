//
//  ContentRowView.swift
//  LikeCoodinatorLayoutExample
//
//  Created by 酒井文也 on 2023/09/14.
//

import SwiftUI

struct ContentRowView: View {

    // MARK: - Property

    let breadEntity: BreadEntity

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            // 1. 商品名前表記
            Text(breadEntity.name)
                .font(.system(size: 16.0, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.vertical, 12.0)
            // 2. メイン情報表示部分
            HStack(spacing: 0.0) {
                // 2-(1). サムネイル用画像表示
                Image(breadEntity.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .cornerRadius(4.0)
                    .frame(width: 120.0, height: 80.0)
                    .background(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color.secondary.opacity(0.5))
                    )
                // 2-(2). サマリー文言表示
                VStack(alignment: .leading) {
                    Text(breadEntity.summary)
                        .font(.system(size: 12.0, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding([.leading], 12.0)
                // 2-(3). Spacer
                Spacer()
            }
            // 3. 注意文言表記
            HStack(spacing: 0.0) {
                Text("※現在商品は店舗販売のみ取り扱っております。")
                    .font(.system(size: 11.0, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12.0)
            }
            // 4. 下側Divider
            Divider()
                .background(Color(uiColor: .lightGray))
        }
        .padding(.horizontal, 16.0)
    }
}
