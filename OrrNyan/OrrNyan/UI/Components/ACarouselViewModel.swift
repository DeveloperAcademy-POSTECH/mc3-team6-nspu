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

    init(_ data: Data, id: KeyPath<Data.Element, ID>, index: Binding<Int>, spacing: CGFloat, headspace: CGFloat, sidesScaling: CGFloat, isWrap: Bool) {
        guard index.wrappedValue < data.count else {
            fatalError("The index should be less than the count of data ")
        }

        _data = data
        _dataId = id
        _spacing = spacing
        _headspace = headspace
        _isWrap = isWrap
        _sidesScaling = sidesScaling

        if data.count > 1 && isWrap {
            activeIndex = index.wrappedValue + 1
        } else {
            activeIndex = index.wrappedValue
        }

        _index = index
    }

    /// The index of the currently active subview.
    @Published var activeIndex: Int = 0 {
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
    var viewSize: CGSize = .zero
}

extension ACarouselViewModel where ID == Data.Element.ID, Data.Element: Identifiable {
    convenience init(_ data: Data, index: Binding<Int>, spacing: CGFloat, headspace: CGFloat, sidesScaling: CGFloat, isWrap: Bool) {
        self.init(data, id: \.id, index: index, spacing: spacing, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap)
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

    // 스테이지의 스케일을 조정하는 함수입니다.
    // StageView에서 인터랙션이 일어날 때마다 실행됩니다.
    // activeIndex 양 옆의 스케일을 다르게 줍니다.
    /// Defines the scaling based on whether the item is currently active or not.
    /// - Parameter item: The incoming item
    /// - Returns: scaling
    func itemScaling(_ item: Data.Element) -> CGFloat {
        guard activeIndex < data.count else {
            return 0
        }
        let tempItem = item as! Item
        if activeIndex == tempItem.index {
            return 1
        } else if activeIndex < tempItem.index {
            return 1.2
        }
        else {
            return 0.8
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
//        return max(min(_sidesScaling, 1), 0)
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
        let activeOffset = CGFloat(activeIndex) * itemActualWidth
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
                self.activeIndex = self.data.count - 2
                self.isAnimatedOffset = false
            }
        } else if offset == maxinumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = 1
                self.isAnimatedOffset = false
            }
        }
    }
}

// MARK: - Drag Gesture

extension ACarouselViewModel {
    // 뷰가 드래그됐을 때. 드래그 시작 시 dragChanged, 끝날 시 dragEnded
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
        // 드래그되는 값을 value.translation.width로 가져옴

        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }

        // 현재 드래그된 값을 dragOffset에 저장
        /// set drag offset
        dragOffset = offset
    }

    private func dragEnded(_ value: DragGesture.Value) {
        /// reset drag offset
        dragOffset = .zero

        /// Defines the drag threshold
        /// At the end of the drag, if the drag value exceeds the drag threshold,
        /// the active view will be toggled
        /// default is one third of subview
        let dragThreshold: CGFloat = itemWidth / 3

        var activeIndex = self.activeIndex
        // 이전으로 드래그할때 && 한계점 넘었을 때
        if value.translation.width > dragThreshold {
            activeIndex -= 1
//            _sidesScaling = 1.2
        }
        // 다음 방향으로 드래그할때 && 한계점 넘었을 때
        if value.translation.width < -dragThreshold {
            activeIndex += 1
//            _sidesScaling = 0.8
        }
        // activeIndex가 음수가 되는 것 방지, activeIndex가 최댓값을 넘어가는 것 방지
        self.activeIndex = max(0, min(activeIndex, data.count - 1))
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
