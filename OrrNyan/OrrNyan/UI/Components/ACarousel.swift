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
    @EnvironmentObject var stageViewModel: StageViewModel

    // ACarousel에 들어갈 Content(View)를 content에 저장합니다.
    private let content: (Data.Element) -> Content

//    @Namespace var nameSpace
    var nameSpace: Namespace.ID
    public var body: some View {
        GeometryReader { proxy in
//            viewModel.viewSize = proxy.size
//            return AnyView(generateContent(proxy: proxy, nameSpace: nameSpace))
            ZStack {
                HStack(spacing: viewModel.spacing) {
                    ForEach(viewModel.data, id: viewModel.dataId) { element in
                        let tempElement = element as! StageItem

                        // Carousel로 사용할 컨텐츠들을 배치합니다.
                        VStack(spacing: 0) {
                            ZStack {
                                tempElement.image
                                    .resizable()
                                    .scaledToFill()
//                                    .scaleEffect(x: 1.15, y: viewModel.itemScaling(element), anchor: .bottom)
                                    .grayscale(viewModel.grayScaling(element))
                                    .blur(radius: viewModel.blur(element))
                                    .opacity(viewModel.opacityScaling(element))
                                    .matchedGeometryEffect(id: "StageStImage0\(tempElement.index + 1)", in: nameSpace)
                                    .frame(width: viewModel.itemWidth)
                                    .onTapGesture {
                                        if UserDefaults.standard.object(forKey: "stageActiveIndex") as! Int == tempElement.index && userStageTestInstance.currentStage > tempElement.index {
                                            UserDefaults.standard.set(tempElement.index, forKey: "selectedStageIndex")
                                            stageViewModel.selectedIndex = tempElement.index
                                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
                                                stageViewModel.isMainDisplayed = true
                                            }
                                        }
                                    }
//                                    .overlay(Rectangle().fill(.red).opacity(0.3))
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.White300)
                                    .font(.system(size: 30))
                                    .shadow(radius: 7)
                                    .opacity(viewModel.buttonOpacity(element))
                            }
                            .overlay(Rectangle().opacity(0.5))
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Image("TextDivider")
                                        .resizable()
                                        .frame(width: 50, height: 20)
                                    Text(tempElement.name)
                                        .font(.pretendard(size: 24, .bold))
                                    Text("\(tempElement.floors)층")
                                }
                            }
                            .padding(.top, 20)
                            .frame(width: viewModel.itemWidth)
                            .offset(x: 30)
                            .opacity(viewModel.activeIndex == tempElement.index ? 1 : 0)
                        }
                    }
                }
                .frame(width: proxy.size.width, alignment: .leading)
                .offset(x: viewModel.offset)
                .gesture(viewModel.dragGesture)
                .animation(viewModel.offsetAnimation)

                // forward, backward button
                HStack {
                    Button {
                        viewModel.reduceActiveIndex()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .opacity(viewModel.activeIndex == 0 ? 0 : 1)
                    Spacer()
                    Button {
                        viewModel.increaseActiveIndex()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .opacity(viewModel.activeIndex == viewModel.data.count - 1 ? 0 : 1)
                }
                .font(.system(size: 24, weight: .medium))
                .padding(.horizontal, 20)
                .foregroundColor(.Gray100)
                .zIndex(100)
            }
//            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
        }
        .clipped()
    }

//    private func generateContent(proxy: GeometryProxy, nameSpace: Namespace.ID) -> some View {
//        ZStack {
//            HStack(spacing: viewModel.spacing) {
//                ForEach(viewModel.data, id: viewModel.dataId) { element in
//                    let tempElement = element as! StageItem
//                    let a = tempElement.image
//                    // Carousel로 사용할 컨텐츠들을 배치합니다.
//                    VStack {
//                        ZStack {
//                            tempElement.image
//                                .resizable()
//                                .scaledToFill()
    ////                            content(a as! Data.Element)
//                                .frame(width: viewModel.itemWidth)
//                                .scaleEffect(x: 1, y: viewModel.itemScaling(element), anchor: .bottom)
//                                .grayscale(viewModel.grayScaling(element))
//                                .blur(radius: viewModel.blur(element))
//                                .opacity(viewModel.opacityScaling(element))
//                                .matchedGeometryEffect(id: "StageStImage0\(tempElement.index + 1)", in: nameSpace)
//                                .onTapGesture {
//                                    if UserDefaults.standard.object(forKey: "stageActiveIndex") as! Int == tempElement.index && userStageTestInstance.currentStage > tempElement.index {
//                                        UserDefaults.standard.set(tempElement.index, forKey: "selectedStageIndex")
//                                        stageViewModel.selectedIndex = tempElement.index
//                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
//                                            stageViewModel.isMainDisplayed = true
//                                        }
//                                    }
//                                }
//                            Image(systemName: "lock.fill")
//                                .foregroundColor(.White300)
//                                .font(.system(size: 30))
//                                .shadow(radius: 7)
//                                .opacity(viewModel.buttonOpacity(element))
//                        }
//                    }
//                    .onAppear {}
//                }
//            }
//            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
//            .offset(x: viewModel.offset)
//            .gesture(viewModel.dragGesture)
//            .animation(viewModel.offsetAnimation)
//
//            // forward, backward button
//            HStack {
//                Button {
//                    viewModel.reduceActiveIndex()
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//                .opacity(viewModel.activeIndex == 0 ? 0 : 1)
//                Spacer()
//                Button {
//                    viewModel.increaseActiveIndex()
//                } label: {
//                    Image(systemName: "chevron.right")
//                }
//                .opacity(viewModel.activeIndex == viewModel.data.count - 1 ? 0 : 1)
//            }
//            .font(.system(size: 24, weight: .medium))
//            .padding(.horizontal, 20)
//            .foregroundColor(.Gray100)
//            .zIndex(100)
//        }
//    }
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
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, id: KeyPath<Data.Element, ID>, index: Binding<Int> = .constant(0), spacing: CGFloat = 10, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, grayScaling: Double = 1.0, blurScaling: Double = 1.0, opacityScaling: Double = 0.0, indexScaling: CGFloat = 1.0, nameSpace: Namespace.ID, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        viewModel = ACarouselViewModel(data, id: id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling)
        self.nameSpace = nameSpace
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
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, index: Binding<Int> = .constant(0), spacing: CGFloat = 10, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, grayScaling: Double = 1.0, blurScaling: Double = 0.0, opacityScaling: Double = 1.0, indexScaling: CGFloat = 1.0, nameSpace: Namespace.ID, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        viewModel = ACarouselViewModel(data, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling)
        self.nameSpace = nameSpace
        self.content = content
    }
}

// @available(iOS 14.0, OSX 11.0, *)
// struct ACarousel_LibraryContent: LibraryContentProvider {
//    let Datas = Array(repeating: _Item(color: .red), count: 3)
//    @LibraryContentBuilder
//    var views: [LibraryItem] {
//        LibraryItem(ACarousel(Datas) { _ in }, title: "ACarousel", category: .control)
//        LibraryItem(ACarousel(Datas, index: .constant(0), spacing: 10, headspace: 10, sidesScaling: 0.8, isWrap: false) { _ in }, title: "ACarousel full parameters", category: .control)
//    }
//
//    struct _Item: Identifiable {
//        let id = UUID()
//        let color: Color
//    }
// }
