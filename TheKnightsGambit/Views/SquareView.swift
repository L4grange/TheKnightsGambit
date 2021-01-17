//
//  SquareView.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import UIKit

class SquareView: UILabel {
	let position: Position

	init(frame: CGRect, position: Position) {
		self.position = position
		super.init(frame: frame)
		commonInit()
	}

	convenience init(row: Int, col: Int) {
		self.init(frame: CGRect.zero, position: Position(row: row, col: col))
	}

	required init?(coder: NSCoder) {
		position = Position(row: 0, col: 0)
		super.init(coder: coder)
		commonInit()
	}

	override init(frame: CGRect) {
		position = Position(row: 0, col: 0)
		super.init(frame: frame)
		commonInit()
	}

	private func commonInit() {
		backgroundColor = squareColor
		textColor = squareTextColor
		minimumScaleFactor = 0.1
		adjustsFontSizeToFitWidth = true
		textAlignment = .center
		baselineAdjustment = .alignCenters
		font = UIFont.systemFont(ofSize: 50)

//		#if DEBUG
//		text = "\(position.row).\(position.col)"
//		#endif
	}

	// MARK: - Computed Properites
	var squareColor: UIColor {
		return (position.row + position.col).isEven ? UIColor.black : UIColor.white
	}

	var squareTextColor: UIColor {
		return (position.row + position.col).isEven ? UIColor.white : UIColor.black
	}

	// MARK: - Functions
	func reset() {
		text = ""
		textColor = squareTextColor
	}

	func select(_ isStartingPosition: Bool) {
		text = Constants.knightFilled
		textColor = isStartingPosition ? squareTextColor : .systemGray
	}

}
