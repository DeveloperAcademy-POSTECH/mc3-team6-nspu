//
//  ACarouselViewModel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
class ACarouselViewModel<Data, ID>: ObservableObject where Data: RandomAccessCollection, ID: Hashable {
    /// external index
    @Binding
    private var index: Int
    private let _data: Data
    private let _dataId: KeyPath<Data.Element, ID>
    private let _spacing: CGFloat
    private let _headspace: CGFloat
    private let _isWrap: Bool
    private var _sidesScaling: CGFloat
    private let _grayScaling: Double
    private let _blurScaling: Double
    private let _opacityScaling: Double
    private var _indexScaling: CGFloat
    private var cancellables = Set<AnyCancellable>()

    init(_ data: Data, id: KeyPath<Data.Element, ID>, index: Binding<Int>, spacing: CGFloat, headspace: CGFloat, sidesScaling: CGFloat, isWrap: Bool, grayScaling: Double, blurScaling: Double, opacityScaling: Double, indexScaling: CGFloat) {
        guard index.wrappedValue < data.count else {
            fatalError("The index should be less than the count of data ")
        }
        _data = data
        _dataId = id
        _spacing = spacing
        _headspace = headspace
        _isWrap = isWrap
        _sidesScaling = sidesScaling
        _grayScaling = grayScaling
        _blurScaling = blurScaling
        _opacityScaling = opacityScaling
        _indexScaling = indexScaling

        if UserDefaults.standard.object(forKey: "focusedStageIndex") == nil {
            UserDefaults.standard.set(User.instance.userStage?.currentStage ?? 0, forKey: "focusedStageIndex")
//            UserDefaults.standard.set(User.instance.userStage?.currentStage ?? 1, forKey: "CurrentStage")
        }
        focusedIndex = UserDefaults.standard.object(forKey: "focusedStageIndex") as! Int
        currentStage = User.instance.userStage?.currentStage ?? 1
        _index = index
        NotificationCenter.default.publisher(for: .userStageCurrentStageChanged)
            .compactMap { notification in
                notification.userInfo?["currentStage"] as? Int
            }
            .sink { [weak self] newValue in
                self?.focusedIndex = newValue - 1
            }
            .store(in: &cancellables)
    }

    /// The index of the currently active subview.
    @Published var focusedIndex: Int = 0 {
        willSet {
            if isWrap {
                if newValue > _data.count || newValue == 0 {
                    return
                }
                index = newValue - 1
            } else {
                index = newValue
            }
        }
        didSet {
            changeOffset()
        }
    }

    /// Offset x of the view drag.
    @Published var dragOffset: CGFloat = .zero

    /// size of GeometryProxy
    var viewSize: CGSize = .init(width: UIScreen.width, height: UIScreen.height)

    /// currentStage
    @Published var currentStage: Int = User.instance.userStage?.currentStage ?? 1
    
    /// reduce active index by 1
    func decreaseFocusedIndex() {
        focusedIndex = max(0, focusedIndex - 1)
        setUserDefaultsFocusedIndex(index: focusedIndex)
    }

    /// increase active index by 1
    func increaseFocusedIndex() {
        focusedIndex = min(focusedIndex + 1, data.count - 1)
        setUserDefaultsFocusedIndex(index: focusedIndex)
    }

    /// syuc focused index with currentStage
    func syncFocusedIndex() {
        focusedIndex = (User.instance.userStage?.currentStage ?? 1) - 1
        setUserDefaultsFocusedIndex(index: focusedIndex)
    }

    func setUserDefaultsFocusedIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: "focusedStageIndex")
    }
}

extension ACarouselViewModel where ID == Data.Element.ID, Data.Element: Identifiable {
    convenience init(_ data: Data, index: Binding<Int>, spacing: CGFloat, headspace: CGFloat, sidesScaling: CGFloat, isWrap: Bool, grayScaling: Double, blurScaling: Double, opacityScaling: Double, indexScaling: CGFloat) {
        self.init(data, id: \.id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, grayScaling: grayScaling, blurScaling: blurScaling, opacityScaling: opacityScaling, indexScaling: indexScaling)
    }
}

extension ACarouselViewModel {
    var data: Data {
        guard _data.count != 0 else {
            return _data
        }
        guard _data.count > 1 else {
            return _data
        }
        guard isWrap else {
            return _data
        }
        return [_data.last!] + _data + [_data.first!] as! Data
    }

    var dataId: KeyPath<Data.Element, ID> {
        return _dataId
    }

    var spacing: CGFloat {
        return _spacing
    }

    var offsetAnimation: Animation? {
        guard isWrap else {
            return .spring()
        }
        return isAnimatedOffset ? .spring() : .none
    }

    var itemWidth: CGFloat {
        viewSize.width - defaultPadding * 2
    }

    var indexScaling: CGFloat {
        return _indexScaling
    }

    func grayScaling(_ item: Data.Element) -> Double {
        guard focusedIndex < data.count else {
            return 0.0
        }
        let tempItem = item as! StageItem
        // 현재 클리어중인 스테이지보다 높은 스테이지는 흑백처리
        if (User.instance.userStage?.currentStage ?? 1) - 1 < tempItem.index {
            return 1.0
        }
        else {
            return 0.0
        }
    }

    /// 현재 포커싱된 스테이지가 아닌 스테이지의 블러 조절
    func stageBlur(_ item: Data.Element) -> Double {
        guard focusedIndex < data.count else {
            return 0.0
        }
        let tempItem = item as! StageItem
        if focusedIndex != tempItem.index {
            return abs(indexScaling) * 4.0
        }
        else {
            return 4.0 * (1.0 - abs(indexScaling))
        }
    }

    /// 현재 포커싱된 스테이지가 아닌 스테이지의 투명도 조절
    func opacityScaling(_ item: Data.Element) -> Double {
        guard focusedIndex < data.count else {
            return 1.0
        }
        let tempItem = item as! StageItem
        if focusedIndex != tempItem.index {
            return 0.3
        }
        else if (User.instance.userStage?.currentStage ?? 1) - 1 < tempItem.index {
            return 0.6
        }
        else {
            return 1.0
        }
    }

    /// 처음과 마지막 스테이지에서 나타나는 화살표 투명도 조절
    func buttonOpacity(_ item: Data.Element) -> Double {
        guard focusedIndex < data.count else {
            return 1.0
        }
        let tempItem = item as! StageItem

        if (User.instance.userStage?.currentStage ?? 1) - 1 < tempItem.index {
            return 1.0
        }
        else {
            return 0.0
        }
    }

    // 스와이프 시 나타나는 스테이지의 스케일을 조절
    // StageView에서 인터랙션이 일어날 때마다 실행됩니다.
    // focusedIndex 양 옆의 스케일을 다르게 줍니다.
    /// Defines the scaling based on whether the item is currently active or not.
    /// - Parameter item: The incoming item
    /// - Returns: scaling
    func itemScaling(_ item: Data.Element) -> CGFloat {
        guard focusedIndex < data.count else {
            return 0
        }
        let tempItem = item as! StageItem
        // 현재 스테이지 스케일 - 1.0
        if focusedIndex == tempItem.index {
            if indexScaling == 1 {
                return 1.0
            } else {
                return 1.0 + 0.2 * indexScaling
            }
        }
        // 현재 이후 스테이지 스케일 - 1.2
        else if focusedIndex < tempItem.index {
            if indexScaling == 1 {
                return 1.2
            } else {
                return 1.2 + 0.2 * indexScaling
            }
        }
        // 현재 이전 스테이지 스케일 - 0.8
        else {
            if indexScaling == 1 {
                return 0.8
            } else {
                return 0.8 + 0.2 * indexScaling
            }
        }
    }

    /// 스와이프 시 고양이의 투명도 조절
    func catOpacityScaling(_ item: Data.Element) -> CGFloat {
        let tempItem = item as! StageItem
        if focusedIndex == tempItem.index {
            if indexScaling == 1 {
                return 1
            }
            else {
                return 1 - abs(indexScaling)
            }
        }
        else {
            if indexScaling == 1 {
                return 0
            }
            else {
                return abs(indexScaling)
            }
        }
    }

    func flagOpacityScaling(_ item: Data.Element) -> CGFloat {
        let tempItem = item as! StageItem
        if tempItem.index < (User.instance.userStage?.currentStage ?? 1) - 1 {
            return 1
        }
        else {
            return 0
        }
    }

    func flagOffsetScaling(_ item: Data.Element) -> CGFloat {
        let tempItem = item as! StageItem

        if focusedIndex == tempItem.index {
            if abs(indexScaling) == 1 {
                return 1
            } else {
                return 1.0 + indexScaling * 0.4
            }
        }
        // 현재 이후 스테이지 스케일 - 1.2
        else if focusedIndex < tempItem.index {
            if abs(indexScaling) == 1 {
                return 1.35
            } else {
                return 1.35 + indexScaling * 0.4
            }
        }
        // 현재 이전 스테이지 스케일 - 0.8
        else {
            if abs(indexScaling) == 1 {
                return 0.6
            } else {
                return 0.6 + abs(indexScaling) * 0.4
            }
        }
    }
}

// MARK: - private variable

extension ACarouselViewModel {
    private var isWrap: Bool {
        return _data.count > 1 ? _isWrap : false
    }

    private var defaultPadding: CGFloat {
        return (_headspace + spacing)
    }

    // itemActualWidth: 아이템 너비 + 주변 여백
    private var itemActualWidth: CGFloat {
        itemWidth + spacing
    }

    // sidesScaling: 1과 sideScaling의 최솟값, 0이상을 위한 max
    private var sidesScaling: CGFloat {
        return _sidesScaling
    }

    // isAnimatedOffset: 뷰가 offset에 있을 때(drag됐을 때) true
    /// Is animated when view is in offset
    private var isAnimatedOffset: Bool {
        get { UserDefaults.isAnimatedOffset }
        set { UserDefaults.isAnimatedOffset = newValue }
    }
}

// MARK: - Offset Method

extension ACarouselViewModel {
    /// current offset value
    var offset: CGFloat {
        let activeOffset = CGFloat(focusedIndex) * itemActualWidth
        return defaultPadding - activeOffset + dragOffset
    }

    /// change offset when acitveItem changes
    private func changeOffset() {
        isAnimatedOffset = true
        guard isWrap else {
            return
        }

        let minimumOffset = defaultPadding
        let maxinumOffset = defaultPadding - CGFloat(data.count - 1) * itemActualWidth

        if offset == minimumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.focusedIndex = self.data.count - 2
                self.isAnimatedOffset = false
            }
        } else if offset == maxinumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.focusedIndex = 1
                self.isAnimatedOffset = false
            }
        }
    }
}

// MARK: - Drag Gesture

extension ACarouselViewModel {
    /// drag gesture of view
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }

    private func changeSidesScaling(scale: CGFloat) {
        _sidesScaling = scale
    }

    private func dragChanged(_ value: DragGesture.Value) {
        // 드래그 시작됐으니 isAnimatedOffset = true
        isAnimatedOffset = true

        // 드래그 최댓값 설정
        // 한 번에 여러 개의 subview(카드) 드래그 방지
        // 하나의 카드만 드래그할때
        /// Defines the maximum value of the drag
        /// Avoid dragging more than the values of multiple subviews at the end of the drag,
        /// and still only one subview is toggled
        // offset을 한 카드의 실제 너비로 설정
        var offset: CGFloat = itemActualWidth

        // 수평으로 드래그되는 값을 value.translation.width로 가져와서 offset에 저장
        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }

        // 현재 드래그된 값을 dragOffset에 저장
        /// set drag offset
        dragOffset = offset

        _indexScaling = max(-1.0, min(1.0, 2 * value.translation.width / UIScreen.width))
    }

    private func dragEnded(_ value: DragGesture.Value) {
        /// reset drag offset
        dragOffset = .zero

        /// Defines the drag threshold
        /// At the end of the drag, if the drag value exceeds the drag threshold,
        /// the active view will be toggled
        /// default is one third of subview
        let dragThreshold: CGFloat = itemWidth / 3

        // 이전으로 드래그할때 && 한계점 넘었을 때
        if value.translation.width > dragThreshold {
            decreaseFocusedIndex()
        }
        // 다음 방향으로 드래그할때 && 한계점 넘었을 때
        if value.translation.width < -dragThreshold {
            increaseFocusedIndex()
        }
        _indexScaling = 1
        // activeIndex가 음수가 되는 것 방지, activeIndex가 최댓값을 넘어가는 것 방지
//        self.focusedIndex = max(0, min(focusedIndex, data.count - 1))
    }
}

private extension UserDefaults {
    private enum Keys {
        static let isAnimatedOffset = "isAnimatedOffset"
    }

    // UserDefaults에 isAnimatedOffset 저장
    static var isAnimatedOffset: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isAnimatedOffset)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAnimatedOffset)
        }
    }
}
