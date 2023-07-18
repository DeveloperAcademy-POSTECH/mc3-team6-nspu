//
//  ACarousel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
public struct ACarousel<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
    // viewModel 인스턴스 생성
    @ObservedObject
    private var viewModel: ACarouselViewModel<Data, ID>
    // ACarousel에 들어갈 Content(View)를 content에 저장합니다.
    private let content: (Data.Element) -> Content

    public var body: some View {
        GeometryReader { proxy -> AnyView in
            viewModel.viewSize = proxy.size
            return AnyView(generateContent(proxy: proxy))
        }.clipped()
    }

    private func generateContent(proxy: GeometryProxy) -> some View {
        HStack(spacing: viewModel.spacing) {
            ForEach(viewModel.data, id: viewModel.dataId) {
                // Carousel로 사용할 컨텐츠들을 배치합니다.
                content($0)
                    .frame(width: viewModel.itemWidth)
                    .scaleEffect(x: 1, y: viewModel.itemScaling($0), anchor: .bottom)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
        .offset(x: viewModel.offset)
        .gesture(viewModel.dragGesture)
        .gesture(TapGesture().onEnded {
            print(viewModel.activeIndex)
        })
        .animation(viewModel.offsetAnimation)
        .onReceive(timer: viewModel.timer, perform: viewModel.receiveTimer)
        .onReceiveAppLifeCycle(perform: viewModel.setTimerActive)
    }
}

struct ItemWithIndex<T> {
    let index: Int
    let item: T
}

// MARK: - Initializers

@available(iOS 13.0, OSX 10.15, *)
public extension ACarousel {
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data that the ``ACarousel`` instance uses to create views
    ///     dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - index: The index of currently active.
    ///   - spacing: The distance between adjacent subviews, default is 10.
    ///   - headspace: The width of the exposed side subviews, default is 10
    ///   - sidesScaling: The scale of the subviews on both sides, limits 0...1,
    ///     default is 0.8.
    ///   - isWrap: Define views to scroll through in a loop, default is false.
    ///   - autoScroll: A enum that define view to scroll automatically. See
    ///     ``ACarouselAutoScroll``. default is `inactive`.
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, id: KeyPath<Data.Element, ID>, index: Binding<Int> = .constant(0), spacing: CGFloat = 10, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, autoScroll: ACarouselAutoScroll = .inactive, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        viewModel = ACarouselViewModel(data, id: id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, autoScroll: autoScroll)
        self.content = content
    }
}

@available(iOS 13.0, OSX 10.15, *)
public extension ACarousel where ID == Data.Element.ID, Data.Element: Identifiable {
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ACarousel`` instance uses to
    ///     create views dynamically.
    ///   - index: The index of currently active.
    ///   - spacing: The distance between adjacent subviews, default is 10.
    ///   - headspace: The width of the exposed side subviews, default is 10
    ///   - sidesScaling: The scale of the subviews on both sides, limits 0...1,
    ///      default is 0.8.
    ///   - isWrap: Define views to scroll through in a loop, default is false.
    ///   - autoScroll: A enum that define view to scroll automatically. See
    ///     ``ACarouselAutoScroll``. default is `inactive`.
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, index: Binding<Int> = .constant(0), spacing: CGFloat = 10, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, autoScroll: ACarouselAutoScroll = .inactive, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        viewModel = ACarouselViewModel(data, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, autoScroll: autoScroll)
        self.content = content
    }
}

@available(iOS 14.0, OSX 11.0, *)
struct ACarousel_LibraryContent: LibraryContentProvider {
    let Datas = Array(repeating: _Item(color: .red), count: 3)
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(ACarousel(Datas) { _ in }, title: "ACarousel", category: .control)
        LibraryItem(ACarousel(Datas, index: .constant(0), spacing: 10, headspace: 10, sidesScaling: 0.8, isWrap: false, autoScroll: .inactive) { _ in }, title: "ACarousel full parameters", category: .control)
    }

    struct _Item: Identifiable {
        let id = UUID()
        let color: Color
    }
}
