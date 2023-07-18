//
//  FontManager.swift
//  act5
//
//  Created by YouiHyon Kim on 2023/07/16.
//

import SwiftUI

extension Font {
	enum Pretendard {
		case thin
		case extraLight
		case light
		case regular
		case medium
		case semiBold
		case bold
		case extraBold
		case Black
		case custom(String)
		
		var value: String {
			switch self {
			case .thin:
				return "Pretendard-Thin"
			case .extraLight:
				return "Pretendard-ExtraLight"
			case .light:
				return "Pretendard-Light"
			case .regular:
				return "Pretendard-Regular"
			case .medium:
				return "Pretendard-Medium"
			case .semiBold:
				return "Pretendard-SemiBold"
			case .bold:
				return "Pretendard-Bold"
			case .extraBold:
				return "Pretendard-ExtraBold"
			case .Black:
				return "Pretendard-Black"
				
			case .custom(let name):
				return name
			}
		}
	}

	static func pretendard(size: CGFloat = 13, _ type: Pretendard) -> Font {
		return .custom(type.value, size: size)
	}
}
