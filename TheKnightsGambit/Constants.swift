//
//  Constants.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import UIKit

struct Constants {
	// MARK: - Chess Pices
	static let knightOutline = "♘"
	static let knightFilled = "♞"

	// MARK: - Durations
	static let defaultAnimationDuration = 0.3

	// MARK: - Colors
	static let woodColor = UIColor(red: 85.0/255.0, green: 60.0/255.0, blue: 42.0/255.0, alpha: 1.0)

	static let pathColors = [
		UIColor.systemGreen.brightened(by: 0.8),
		UIColor.systemGreen.brightened(by: 1.8),
		UIColor.systemBlue.brightened(by: 0.8),
		UIColor.systemBlue.brightened(by: 1.8),
		UIColor.systemRed.brightened(by: 0.8),
		UIColor.systemRed.brightened(by: 1.8),
		UIColor.systemGray.brightened(by: 0.8),
		UIColor.systemGray.brightened(by: 1.4),
		UIColor.systemPink.brightened(by: 0.8),
		UIColor.systemPink.brightened(by: 1.8),
		UIColor.systemOrange.brightened(by: 0.8),
		UIColor.systemOrange.brightened(by: 1.8),
	]

	// MARK: - Other Values
	static let aUnicodeScalar = Int(UnicodeScalar("a").value)

}
