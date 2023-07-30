//
//  GetHeightModifier.swift
//  act5
//
//  Created by YouiHyon Kim on 2023/07/11.
//

import SwiftUI

struct ContentRectSize : PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
	
}

struct GetHeightModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.background(GeometryReader {
				Color.clear.preference(key: ContentRectSize.self,
											  value: $0.frame(in: .local))
			})
	}
}

