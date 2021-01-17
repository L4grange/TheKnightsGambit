//
//  ChessViewController.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import UIKit

class ChessViewController: UIViewController {

	// MARK: - Model
	var selectedPositions = [Position]()

	private var dimentions = 8 {
		didSet {
			dimentionsLabel.text = "\(dimentions) 𝗑 \(dimentions)"
			updateBoardSize()
		}
	}

	// MARK: - View
	@IBOutlet weak var chessView: ChessBoardView!
	@IBOutlet weak var dimentionsLabel: UILabel!
	@IBOutlet weak var dimentionStepper: UIStepper!


	override func viewDidLoad() {
		super.viewDidLoad()
		dimentionStepper.value = 8
		chessView.delegate = self
		updateBoardSize()
	}

	private func updateBoardSize() {
		selectedPositions.removeAll()
		chessView.dimentions = dimentions
	}

	fileprivate func resetBoard() {
		selectedPositions.removeAll()
		chessView.resetBoard()
	}

	// MARK: - IBActions
	@IBAction func dimentionsChanged(_ sender: UIStepper) {
		dimentions = Int(sender.value)
	}

	@IBAction func runButtonTapped(_ sender: UIButton) {
		if selectedPositions.count == 2 {
			let paths = ChessSolver.getKnightMoves(from: selectedPositions[0], endPosition: selectedPositions[1], for: chessView.dimentions)
			if !paths.isEmpty {
				chessView.drawKnightPaths(paths)
			} else {
				let alert = UIAlertController(title: "No paths found", message: "The knight cannot reach the selected end position in 3 moves. Do you want to reset the board and try again?", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
					self?.resetBoard()
				})
				alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		} else {
			let alert = UIAlertController(title: "Where to go?", message: "You need to select a start and ending position for the knight before galloping!", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}

}

// MARK: - ChessBoardViewDelegate
extension ChessViewController: ChessBoardViewDelegate {

	func shouldSelectSquare(_ square: SquareView) -> Bool {
		return !selectedPositions.contains(square.position) && selectedPositions.count < 2
	}

	func didSelectSquare(_ square: SquareView) {
		guard !selectedPositions.contains(square.position) else {
			return
		}

		switch selectedPositions.count {
		case 2:
			showResetWarning(square: square)
		default:
			selectedPositions.append(square.position)
		}
	}

	private func showResetWarning(square: SquareView) {
		let alert = UIAlertController(title: nil, message: "Are you sure you want to reset the board?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
			self?.resetBoard()
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
			square.reset()
		})

		self.present(alert, animated: true, completion: nil)
	}
}

