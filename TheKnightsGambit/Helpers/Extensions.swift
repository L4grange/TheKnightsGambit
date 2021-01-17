//
//  Extensions.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import UIKit

extension BinaryInteger {
	var isEven: Bool {
		isMultiple(of: 2)
	}

	var isOdd: Bool {
		!isEven
	}
}

extension UIColor {
	/// Returns a brighter version of the color for values > 1 and a  darker one for values < 1
	func brightened(by factor: CGFloat) -> UIColor {
		var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
	}
}
