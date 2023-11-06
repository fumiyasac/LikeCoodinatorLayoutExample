## はじめに

(こちらは、GMOインターネットグループ有志による技術同人誌に寄稿した原稿になります。)

私事ではありますが、今年の9月14日〜9月16日に開催された「DroidKaigi2023」の公式アプリのiOS側のUI実装に関連したコントリビューションをしました。平素の業務内でもiOS/Android双方のコードを読みながら新規機能開発に携わった経験や、これまでもiOSアプリにおけるUI実装関連のアウトプットをしてきた経験を生かすことができた様に感じております。また、これまで関心がありながらも触れる機会がなかったKMM（Kotlin Multiplatform Mobile）を利用したモバイルアプリ開発を実際に体験できた点は、私にとっても新たな発見や驚きに繋がり非常に有意義だったと強く感じています。

※余談ではありますが、私以外にもminne事業部のAndroidエンジニアが「DroidKaigi2023」の公式アプリのコントリビューションをしています！

これから本題に入ります。読者のみなさまが普段から慣れ親しんで利用しているモバイルアプリでも、「UI表現が特徴的で印象に残っているアプリ」や「思わずこのUI表現をどの様な手法で実現しているかが気になるアプリ」があると思います。しかしながら、この様なUI表現を試行錯誤する過程では、想像以上にUI実装の難易度が高かったり、利用可能なView関連要素がiOSないしはAndroidでそもそも提供されていない場合は自前で作成する必要があるなど、壁に当たってしまう様な場面も多くあります。

実際に私がコントリビューションを担当したUI実装関連部分が、その場面に該当する部分でした。例えば、Android側でJetpack Composeを利用して実現するUI実装関連処理を、iOS側でSwiftUIを利用した際はどの様に実現するためのアプローチしていくか？と言った様な問いは、その逆も然りとはいえ平素の業務内でも直面する機会はあるかもしれません。

本章では、DroidKaigi2023の公式アプリ内で私が担当したiOS側のUI実装関連部分を題材に、iOS/Android間で近しいUI実装や表現を実現するためのアプローチ事例や工夫を施す必要があるポイントを解説できればと思います。

## 1. DroidKaigi2023の公式アプリを参考にしてAndroid側での実装方針を探る

DroidKaigi2023の公式アプリでは、Androidアプリ側の実装が先行していた経緯もあり、まずは該当画面における実装調査を進めました。今回の調査対象はアプリ起動時に表示されるタイムスケジュールを表示する画面でしたので、関連するJetpack Compose製のView要素に焦点を当て、下記にピックアップしたUI実装については重点的に実施しました。

1. 背景要素のAnimationを伴うタブ形式のHeader要素レイアウト 
2. Y軸方向のスクロール変化量に伴うHeader要素の折りたたみ処理
3. タイムライン表示部分を上方向にスクロールすると画像表示が隠れる表現

また、SwiftUIとJetpack Composeそれぞれのプラットフォームで提供されているUI部品要素における名称やキーワードと合わせて、共通点・類似点・相違点・一方のOSで対応するUI部品要素がもう一方のOSで提供されているか？などに注目しながら調査を進める様にすると、イメージがより掴みやすくなるかと思います。

### 1-1. Jetpack Compose製のView構造を元に必要な要素を整理する

DroidKaigi2023の公式アプリ内の該当画面におけるView構造を概要をまとめると、下図の様になります。

![DroidKaigi2023公式アプリAndroid側のView要素の関係を探る](https://user-images.githubusercontent.com/949561/270631076-aac562d5-517c-42c3-9427-ff1152cb1367.png)

### 1-2. 動きを実現している部分の理解を深める

View構造を把握する上での重要なポイントは「タブ型表示をするHeader要素の振る舞いをスクロール変化量と連動する形にする」という部分にあると思い、まずはJetpack Composeで作られたView要素において、NestedScrollViewに関する部分の理解を深める事にしました。

Jetpack Composeが登場する以前にもCoodinatorLayoutと組み合わせて、スクロールと連動した処理を考える際にも、NestedScrollViewを利用することでHeader要素を折りたたむ様な表現をはじめとして様々な応用が可能です。

これらの点を踏まえて、下記に示す様な参考資料を元にしながら、理解を深めた上でiOS側の実装に置き換えて考えることにしました。

__【基本事項を理解するための参考資料】__

- Android公式ドキュメントでのScroll関連の記述
  - https://developer.android.com/jetpack/compose/gestures?hl=ja#scrolling
- Jetpack Compose & NestedScrollView Simple Example
  - https://github.com/Tlaster/NestedScrollView/tree/master

__【更に理解を深める際に参考にしたリンク集】__

- AndroidのCoordinatorLayoutを使いこなして、モダンなスクロールを実装しよう
  - https://techblog.yahoo.co.jp/android/androidcoordinatorlayout/
- NestedScrollViewの仕組み
  - https://qiita.com/takahirom/items/2978ede8e7d40b888832
- 【Jetpack Compose】Pagerを使った画面でもCollapsing Toolbarを実装したい
  - https://qiita.com/yasukotelin/items/b8d084ed783f5c698de3
- Jetpack ComposeでCoordinatorLayoutを実現する
  - https://qiita.com/iwata-n/items/e7c5e8db0f9fbb8c288b
- Master of NestedScroll
  - https://speakerdeck.com/reoandroider/master-of-nestedscroll

## 2. SwiftUIで類似した表現を実現するための方針を考える

次に、Android側のView階層構造や内部実装に関する調査を踏まえて、iOS側でのUI実装方針を組み立てていきます。今回の場合は、Jetpack Composeで提供されているView関連要素を利用を中心に据えて、スクロール変化量に伴い変化する表現を加えた実装となっていました。SwiftUIでは、Jetpack ComposeでのTab & TabRow・NestedScrollConnectionに相当するView関連要素や機能がなさそうだった点や、コントリビューション前の途中段階での実装内容も考慮した上で、下記の様な工夫が必要に感じました。

__【SwiftUIで再現をする際に課題になりうる部分】__

1. タブ型表示要素のButton部分の背景矩形部分の切り替えAnimationは、GeometryReaderから取得した位置を利用して自前で実装する必要がある。
2. SwiftUIのScrollViewではそのままではOffset値を取得できないので、ScrollViewを拡張する or UIScrollViewをSwiftUIで利用するかの判断が必要となる。

SwiftUIでのUI実装を進めていく場合において、UIKitで使っていた機能に対応するものがない場合はUIViewRepresentableを利用することで、SwiftUIで足りない機能を補うアプローチもできますが、DroidKaigi2023の公式アプリではSwiftUIを前提としたProjectで作成されていたため、今回はSwiftUIを前提として全ての実装を進めることにしました。

※ コントリビューション当時にまとめた構造の設計をまとめたノートも、X(旧Twitter)にて公開していますので、興味がある読者の方は併せて参考にして頂けますと幸いです。

- (1) タブ型表示部分のAnimation表現に関連するメモ
  - https://twitter.com/fumiyasac/status/1693501752811917546
- (2) 検索時のハイライト表示とスクロール変化量に伴いタブ型表示部分の高さが変化する表現に関連するメモ
  - https://twitter.com/fumiyasac/status/1695835586719044047

## 3. 簡単なサンプルから要点を紐解いてみる

本章では、DroidKaigi2023の公式アプリでの実装を参考にして、該当部分の動きを再現したUI実装サンプルをコードを交えて紹介します。紹介する実装サンプルでは、API通信処理などの処理はありませんが、後述するView要素関連処理部分のコード内には解説コメントを記載しておりますので、理解の参考になれば幸いです。

![SwiftUIを利用して類似した処理を実現する場合の実装方針概要](https://user-images.githubusercontent.com/949561/270631106-4e675b09-b5a0-4f49-9541-2cf0645f39c5.png)

### 3-1. ScrollViewでOffset値を取得可能にする工夫

```swift
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
```

### 3-2. ViewModelクラスと連動した表示内容切り替え処理

```swift
import Foundation

// Header要素に配置するボタン表示に関するEnum定義
enum BreadList: String, CaseIterable {
    case first
    case second
    case third

    var title: String {
        switch self {
        case .first:
            "1番目"
        case .second:
            "2番目"
        case .third:
            "3番目"
        }
    }

    var subtitle: String {
        switch self {
        case .first:
            "🍞first"
        case .second:
            "🥐second"
        case .third:
            "🍩third"
        }
    }
}

@MainActor
final class ContentViewModel: ObservableObject {

    // MARK: - Property (@Published)
    // View要素表示で利用する値を保持するための変数
    @Published private(set) var selectedBreadList: BreadList = .first
    @Published private(set) var selectedBreadEntities: [BreadEntity] = []

    // MARK: - Initializer
    init() {
        // 初期化時は`BreadList.first`に対応する要素を表示する
        makeSelectedBreadEntities(breadList: .first)
    }

    // MARK: - Function
    // ボタンクリック処理で選択されたBreadList(enum定義)が変更された際に実行する
    func selectBreadList(breadList: BreadList) {
        selectedBreadList = breadList
        makeSelectedBreadEntities(breadList: breadList)
    }

    // MARK: - Private Function
    private func makeSelectedBreadEntities(breadList: BreadList) {

        // 選択されたBreadList(enum定義)に該当する要素一覧を作成する
        selectedBreadEntities = (1...16).map { index in
            BreadEntity(
                name: "...(サンプルの名前が入ります)...",
                summary: "...(サンプルのサマリー文言が入ります)...",
                imageName: "...(サンプルの画像名が入ります)...)"
            )
        }
    }
}
```

### 3-3. GeometryReaderを利用した位置計算を利用したAnimation処理

```swift
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
```

### 3-4. Header要素がNavigationBar到達時の振る舞い ＆ 表示内容切り替え処理とUI表現を連動する形を実現する

```swift
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
```

## 余談. UIKitの場合はどの様なアプローチが考えられるか？

ここまではSwiftUIを利用した場合における解説をしてきましたが、一方でUIKitを用いた実装の場合についても軽く触れておくことにします。前述した解説でもある通り、SwiftUIのScrollViewを利用する際はスクロール変化量を取得するために、PreferenceKeyとGeometryReaderを組み合わせることで実現しましたが、UIKitのUIScrollViewをベースに実装をする場合は、下記のDelegateメソッドを利用することになります。

__【UIScrollViewDelegate】__

- optional func scrollViewDidScroll(_ scrollView: UIScrollView)

スクロール変化量の取得処理部分はすぐに実現が可能な一方で、Header要素がNavigationBar到達時の振る舞いを実現する際には、画面に必要なView要素の位置関係に関する考慮はもとより、AutoLayoutで付与した制約値をスクロール変化量と連動しながら変更する必要があるなど、想像以上に難しさを伴う部分が出てくる思います。

UIKitを利用した場合においては、より細やかな表現が可能なメリットがある一方で、View構造や配置要素の関係性が見えにくい点やAutoLayoutとスクロール処理との連動処理部分の難しさというデメリットもあります。一概にどちらがより優れているかは言えませんし、状況次第でその選択は変化すると思いますが、実装を検討をする際に頭の片隅に置いておくと良いかもしれません。

## まとめ

本章では、Androidアプリ側のUI実装において、NestedScrollView（CoodinatorLayout）とタブ型表示レイアウトの組み合わせを基本方針とし、更に応用として画面のスクロール変化量に応じてタブ型表示部分のサイズを変化する様な振る舞いを、iOS側で類似したUI実装をするためのアプローチと手段の事例をご紹介しました。

今回紹介した実装方針で重要な点は、下記の3点になります。

1. SwiftUIのScrollViewに対してY軸方向のOffset値を取得できる形にカスタマイズを加える
2. 局所的にGeometryReaderを利用して最終的なAnimation到達位置を算出する
3. それぞれ関連するViewにおける重なりを伴う位置関係を整理する

これらを分解して1つ1つの処理に注目するとシンプルに思えるかもしれませんが、これらを組み合わせた上で違和感のない形や動きを実現する場合は、想像以上に難易度が上がることや実装時の配慮が必要になることもあるので、あるべき理想の形から逆算しながらカスタマイズの実施範囲に関する議論や、類似した動きが実現可能なOSSや代替実装の検討等、その先を見据えた準備をしておくと良さそうに思います。

また、iOS＆Androidで類似したUI表現を見比べる際には「プラットフォームレベルで提供されているものがあるか？」という観点も重要な判断材料になり得ます。iOS＆AndroidでUIの振る舞いを合わせる対応を考える際は、一方のプラットフォームでは部品や機能として提供されているが、もう一方では該当しない場合には、部品や機能として提供されているものを参考にして自前で作成する必要があります。そして、この様な場面に遭遇した際に悩ましいのは「難易度を考慮した実装工数の見積もりが難しい点」と考えています。

実装コストや難易度を踏まえながら、ベストなUI実装に関する選択をするために、

- (iOS)Human Interface Guidelanesや(Android) Material Designの内容を定期的に復習する
- ひと工夫が必要なUI実装に関するアプローチに触れる習慣を少しずつ付ける

様な取り組みをすることで、自分自身の体験や知識を元にした良い判断ができるのではないかと思います。

今回の取り組みを通じ、SwiftUIを利用したUI実装アプローチの探求に更に取り組んでいきたいと強く感じた次第です。

私自身もこれまでは、UIKitの方を取り扱うことが割合として多かったのですが、平素の業務やDroidkaigi公式アプリへのコントリビューションを通じ、改めてSwiftUIのポテンシャルや進化に触れる機会も増えてきました。複雑なUI実装を考えていく場合においては、SwiftUIで提供されている機能だけでは、痒いことに手が届かない場面はあるものの、View側での実装をよりシンプルかつ見通し易い形で考えることができるメリットは大きいと感じております（今回の様な形のUI実装では、UIKitを利用した場合であっても複雑なものになることが予想できます）。

今後も更なる研鑽を重ねながら、SwiftUIを有効活用した、美しく印象的＆機能や体験と調和する様ななUI表現や実現アプローチに関するアウトプットを積極的にできればと考えておりますので、何卒よろしくお願い致します。