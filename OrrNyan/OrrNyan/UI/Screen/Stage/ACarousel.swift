//
//  ACarousel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, *)

public struct ACarousel<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
    // viewModel 인스턴스 생성
    @StateObject
    private var viewModel: ACarouselViewModel<Data, ID>
    @EnvironmentObject var stageViewModel: StageViewModel
	@EnvironmentObject var appFirstLaunch : AppFirstLaunch

    // ACarousel에 들어갈 Content(View)를 content에 저장합니다.
    private let content: (Data.Element) -> Content
    var stageStSvgs: [AnyView] = [AnyView(StageStSvg01()), AnyView(StageStSvg02()), AnyView(StageStSvg03())]
    let lottieOffset: [(CGFloat, CGFloat)] = [(0.13, 0.07), (-0.1, -0.05), (-0.1, -0.08)]
    let pawOffset: [(CGFloat, CGFloat)] = [(-0.08, 0.15), (-0.05, 0.08), (-0.05, -0.01)]
    let catRotationDegree: [Double] = [270, 270, 271]
    let cat3DRotationDegree: [Double] = [180, 0, 0]
    var nameSpace: Namespace.ID
	
	@State var test : Bool = true
    @State var cancellables = Set<AnyCancellable>()

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
                                    .blur(radius: viewModel.stageBlur(element))
                                    .opacity(viewModel.opacityScaling(element))
                                    .matchedGeometryEffect(id: "StageStImage0\(tempElement.index + 1)", in: nameSpace)
                                    .overlay {
                                        // out of range error 잡아주기
                                        if tempElement.index < stageStSvgs.count {
                                            stageStSvgs[tempElement.index]
                                                .foregroundColor(.blue.opacity(0.01))
                                                .onTapGesture {
                                                    if UserDefaults.standard.object(forKey: "focusedStageIndex") as! Int == tempElement.index && userStageTestInstance.currentStage > tempElement.index {
                                                        stageViewModel.selectedIndex = tempElement.index
                                                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
                                                            stageViewModel.isMainDisplayed = true
                                                        }
                                                    }
                                                }
											//앱 처음 실행 시, currentStage 자동 클릭 시키기
												.onAppear {
													if UserDefaults.standard.object(forKey: "focusedStageIndex") as! Int == tempElement.index && userStageTestInstance.currentStage > tempElement.index && appFirstLaunch.isFirstlaunch {
														stageViewModel.selectedIndex = tempElement.index
														withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
															stageViewModel.isMainDisplayed = true
														}
													}
												}
                                        }
                                    }
                                    .frame(width: viewModel.itemWidth)
                                Image("Flag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.width * 0.1)
                                    .offset(x: UIScreen.width * 0.046, y: -UIScreen.height * 0.275 * viewModel.flagOffsetScaling(element))
                                    .zIndex(-10)
                                    .opacity(viewModel.flagOpacityScaling(element))
                                    .blur(radius: viewModel.stageBlur(element))
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.White300)
                                    .font(.system(size: 30))
                                    .shadow(radius: 7)
                                    .opacity(viewModel.buttonOpacity(element))
                                if tempElement.index == userStageTestInstance.currentStage - 1 {
                                    LottieView(filename: "LottieMainViewSit")
                                        .rotationEffect(Angle(degrees: catRotationDegree[tempElement.index]))
                                        .rotation3DEffect(.degrees(cat3DRotationDegree[tempElement.index]), axis: (x: 0, y: 1, z: 0))
                                        .frame(width: UIScreen.width * 0.1, height: UIScreen.width * 0.1)
                                        .offset(x: UIScreen.width * lottieOffset[tempElement.index].0, y: UIScreen.height * lottieOffset[tempElement.index].1)
                                        .opacity(viewModel.catOpacityScaling(element))
                                        .blur(radius: viewModel.stageBlur(element))

                                    VStack(spacing: 2) {
                                        Image(systemName: "pawprint.fill")
                                            .padding(.leading, 20)
                                        Image(systemName: "pawprint.fill")
                                    }
                                    .font(.system(size: 11))
                                    .offset(x: UIScreen.width * pawOffset[tempElement.index].0, y: UIScreen.height * pawOffset[tempElement.index].1)
                                    .opacity(viewModel.catOpacityScaling(element))
                                    .blur(radius: viewModel.stageBlur(element))
                                }
                            }
                            .padding(.top, UIScreen.height * 0.1)

                            // MARK: - Stage Info Text 들어가는 HStack

                            HStack {
                                Spacer()
                                VStack(alignment: .trailing, spacing: 0) {
                                    Image("TextDivider")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.width * 0.13)
                                    Text(tempElement.name)
                                        .font(.pretendard(size: UIScreen.width * 0.057, .bold))
                                        .foregroundColor(.Black100)
                                        .padding(.top, 10)
                                    Text("\(tempElement.floors)층")
                                        .font(.pretendard(size: UIScreen.width * 0.05, .semiBold))
                                        .foregroundColor(.Purple200)
                                        .padding(.top, 3)
                                }
                            }
                            .padding(.top, 20)
                            .frame(width: viewModel.itemWidth)
                            .offset(x: 30)
                            .opacity(viewModel.focusedIndex == tempElement.index ? 1 : 0)
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
                    .opacity(viewModel.focusedIndex == 0 ? 0 : 1)
                    Spacer()
                    Button {
                        viewModel.increaseActiveIndex()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .opacity(viewModel.focusedIndex == viewModel.data.count - 1 ? 0 : 1)
                }
                .font(.system(size: 24, weight: .medium))
                .padding(.horizontal, 20)
                .foregroundColor(.Gray100)
                .zIndex(100)
            }
        }
        .clipped()
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
    ///   - content: The view builder that creates views dynamically.
    init(_ data: Data, id: KeyPath<Data.Element, ID>, index: Binding<Int> = .constant(0), spacing: CGFloat = 10, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, grayScaling: Double = 1.0, blurScaling: Double = 1.0, opacityScaling: Double = 0.0, indexScaling: CGFloat = 1.0, nameSpace: Namespace.ID, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        _viewModel = StateObject(wrappedValue: ACarouselViewModel(data, id: id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling))
//        viewModel = ACarouselViewModel(data, id: id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling)
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
        _viewModel = StateObject(wrappedValue: ACarouselViewModel(data, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling))
//        viewModel = ACarouselViewModel(data, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling)
        self.nameSpace = nameSpace
        self.content = content
    }
}
