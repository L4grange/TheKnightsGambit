//
//  ChessBoardView.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import UIKit

protocol ChessBoardViewDelegate: class {
	func shouldSelectSquare(_ square: SquareView) -> Bool
	func didSelectSquare(_ square: SquareView)
}

class ChessBoardView: UIView {

	// MARK: - Model
	weak var delegate: ChessBoardViewDelegate? = nil
	var dimentions = 0 {
		didSet {
			clearBoard()
			createBoard()
		}
	}

	private var squareViews = [[SquareView]]()
	private var pathLayers = [CAShapeLayer]()
	private var selectedSquareViews = [SquareView]()

	// MARK: - View
	var borderWidth: CGFloat = 8.0
	var isStartingPosition = true
	private var containerView = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		backgroundColor = Constants.woodColor
		layer.cornerRadius = 4.0
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 1.0
		layer.shadowRadius = 10.0
		layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
		layer.rasterizationScale = UIScreen.main.scale
		layer.shouldRasterize = true

		containerView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: topAnchor, constant: borderWidth),
			containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -borderWidth),
			containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderWidth),
			containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -borderWidth)
		])

		createBoard()
	}

	private func createBoard() {
		guard dimentions > 0 else {
			return
		}

		for i in 0..<dimentions {
			squareViews.append([SquareView]())
			for j in 0..<dimentions {
				var previousLeadingViewLayoutAnchor: NSLayoutAnchor = containerView.leadingAnchor
				var previousTopViewLayoutAnchor: NSLayoutAnchor = containerView.topAnchor

				if i > 0 && i < dimentions {
					previousTopViewLayoutAnchor = squareViews[i - 1][j].bottomAnchor
				}

				if j > 0 && j < dimentions  {
					previousLeadingViewLayoutAnchor = squareViews[i][j - 1].trailingAnchor
				}

				let squareView = createSquareView(for: i, j)
				containerView.addSubview(squareView)

				NSLayoutConstraint.activate([
					squareView.widthAnchor.constraint(equalTo: squareView.heightAnchor, multiplier: 1.0), // Aspect ratio
					squareView.leadingAnchor.constraint(equalTo: previousLeadingViewLayoutAnchor),
					squareView.topAnchor.constraint(equalTo: previousTopViewLayoutAnchor),
					squareView.widthAnchor.constraint(equalToConstant: (frame.width - borderWidth * 2) / CGFloat(dimentions))
				])

				squareViews[i].append(squareView)
			}

			// Add the trailing constraint for the last view of the row
			squareViews[i][dimentions - 1].trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		}

		// Add the bottom constraints to the bottom view
		let bottomConstraints = squareViews[dimentions - 1].map {
			$0.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		}
		NSLayoutConstraint.activate(bottomConstraints)
	}

	private func createSquareView(for row: Int, _ col: Int) -> SquareView {
		let view = SquareView(row: row, col: col)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnSquare(_:))))
		view.isUserInteractionEnabled = true
		return view
	}

	// MARK: - Reset functions

	private func clearBoard() {
		squareViews.forEach { $0.forEach { $0.removeFromSuperview() } }
		squareViews.removeAll()
		resetBoard()
	}

	func resetBoard() {
		selectedSquareViews.forEach { $0.reset() }
		selectedSquareViews.removeAll()
		isStartingPosition = true
		resetPathLayers()
	}

	private func resetPathLayers() {
		pathLayers.forEach { $0.removeFromSuperlayer() }
		pathLayers.removeAll()
	}

	// MARK: - Drawing

	func drawKnightPaths(_ paths: [KnightPath]) {
		resetPathLayers()
		print("Found \(paths.count) paths! Drawing knight paths for:\n\(paths)")

		let squareWidth = (bounds.width - borderWidth * 2) / CGFloat(dimentions)
		let squareCenter = squareWidth / 2.0
		var lineWidth: CGFloat = 12.0

		guard let startPosition = selectedSquareViews.first?.position,
			  let endPosition = selectedSquareViews.last?.position else {
			return
		}

		for (index, path) in paths.enumerated() {
			let pathColor = Constants.pathColors[index % 12]
			let firstMove = path.move1
			let secondMove = path.move2

			// Draw the 1st move
			drawLine(from: startPosition, to: firstMove, color: pathColor, lineWidth: lineWidth, squareWidth:  squareWidth, squareCenter: squareCenter)

			// Draw the 2nd move
			drawLine(from: firstMove, to: secondMove, color: pathColor, lineWidth: lineWidth, squareWidth:  squareWidth, squareCenter: squareCenter)

			// Draw the 3rd move
			drawLine(from: secondMove, to: endPosition, color: pathColor, lineWidth: lineWidth, squareWidth:  squareWidth, squareCenter: squareCenter)

			// Adjust the line width
			lineWidth -= 1.5
			if lineWidth < 3.0 {
				lineWidth = 3.0
			}
		}
	}

	func drawLine(from startPosition: Position, to endPosition: Position, color: UIColor, lineWidth: CGFloat, squareWidth: CGFloat, squareCenter: CGFloat) {

		let startX = squareWidth * CGFloat(startPosition.col) + squareCenter
		let startY = squareWidth * CGFloat(startPosition.row) + squareCenter

		let endX = squareWidth * CGFloat(endPosition.col) + squareCenter
		let endY = squareWidth * CGFloat(endPosition.row) + squareCenter

		let path = UIBezierPath()
		path.move(to: CGPoint(x: startX, y: startY))
		path.addLine(to: CGPoint(x: endX, y: endY))

		let lineLayer = CAShapeLayer()
		lineLayer.path = path.cgPath
		lineLayer.strokeColor = color.cgColor
		lineLayer.lineWidth = lineWidth

		containerView.layer.addSublayer(lineLayer)
		pathLayers.append(lineLayer)
	}

	// MARK: - Selectors
	@objc private func didTapOnSquare(_ sender: UITapGestureRecognizer) {
		if let square = sender.view as? SquareView {
			if delegate?.shouldSelectSquare(square) ?? true {
				selectedSquareViews.append(square)
				square.select(isStartingPosition)
				isStartingPosition = false
			}
			delegate?.didSelectSquare(square)
		}
	}

}
