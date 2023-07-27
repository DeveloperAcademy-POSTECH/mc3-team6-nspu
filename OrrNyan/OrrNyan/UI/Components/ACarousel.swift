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

    var nameSpace: Namespace.ID

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack(spacing: viewModel.spacing) {
                    // MARK: - Carousel에 들어갈 컨텐츠들을 배치합니다.

                    ForEach(viewModel.data, id: viewModel.dataId) { element in
                        let tempElement = element as! StageItem

                        VStack(spacing: 0) {
                            // MARK: - Carousel에 배치될 이미지와 잠금 표시를 렌더링합니다.

                            ZStack {
                                tempElement.image
                                    .resizable()
                                    .scaledToFill()
                                    .scaleEffect(x: 1, y: viewModel.itemScaling(element), anchor: .bottom)
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
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.White300)
                                    .font(.system(size: 30))
                                    .shadow(radius: 7)
                                    .opacity(viewModel.buttonOpacity(element))
                            }
                            .padding(.top, UIScreen.main.bounds.height * 0.1)

                            // MARK: - Stage Info Text 들어가는 HStack

                            HStack {
                                Spacer()
                                VStack(alignment: .trailing, spacing: 0) {
                                    Image("TextDivider")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.main.bounds.width * 0.13)
                                    Text(tempElement.name)
                                        .font(.pretendard(size: UIScreen.main.bounds.width * 0.057, .bold))
                                        .foregroundColor(.Black100)
                                        .padding(.top, 10)
                                    Text("\(tempElement.floors)층")
                                        .font(.pretendard(size: UIScreen.main.bounds.width * 0.05, .semiBold))
                                        .foregroundColor(.Purple200)
                                        .padding(.top, 3)
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

                // MARK: - forward, backward button

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
