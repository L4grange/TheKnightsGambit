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
	var knightPaths = [KnightPath]()
	var visiblePathIndex = 0 {
		didSet {
			drawSelectedPath()
		}
	}

	// MARK: - View
	@IBOutlet weak var chessView: ChessBoardView!
	@IBOutlet weak var dimentionsLabel: UILabel!
	@IBOutlet weak var dimentionStepper: UIStepper!
	@IBOutlet weak var pathDescriptionLabel: UILabel!
	@IBOutlet var pathSelectionButtons: [UIButton]!

	override func viewDidLoad() {
		super.viewDidLoad()
		dimentionStepper.value = 8
		chessView.delegate = self
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateBoardSize()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		coordinator.animate(alongsideTransition: {(_ context: Any) -> Void in
		}, completion: {(_ context: Any) -> Void in
			if self.visiblePathIndex < 0 || self.visiblePathIndex == self.knightPaths.count {
				self.drawAllPaths()
			} else {
				self.drawSelectedPath()
			}
		})
	}

	// MARK: - Private Functions

	private func updateBoardSize() {
		selectedPositions.removeAll()
		chessView.dimentions = Int(dimentionStepper.value)
		showPathControls(false)
	}

	fileprivate func resetBoard() {
		selectedPositions.removeAll()
		chessView.resetBoard()
		showPathControls(false)
	}

	private func showPathControls(_ show: Bool) {
		pathDescriptionLabel.isHidden = !show
		pathSelectionButtons.forEach { $0.isHidden = !show }
	}

	private func drawSelectedPath() {
		guard visiblePathIndex >= 0 && visiblePathIndex < knightPaths.count else {
			return
		}
		setPathDescription()
		chessView.drawKnightPaths([knightPaths[visiblePathIndex]], pathIndex: visiblePathIndex)
	}

	private func drawAllPaths() {
		setPathDescription(allPaths: true)
		chessView.drawKnightPaths(knightPaths)
	}

	private func setPathDescription(allPaths: Bool = false) {
		pathDescriptionLabel.text = allPaths
			? "Showing all \(knightPaths.count) paths."
			: "Path \(visiblePathIndex + 1) of \(knightPaths.count): \(knightPaths[visiblePathIndex].notation(for: Int(dimentionStepper.value)))"
	}

	// MARK: - IBActions
	@IBAction func dimentionsChanged(_ sender: UIStepper) {
		let dimentions = Int(sender.value)
		dimentionsLabel.text = "\(dimentions) 𝗑 \(dimentions)"
		updateBoardSize()
	}

	@IBAction func previousButtonTapped(_ sender: UIButton) {
		guard visiblePathIndex > 0 else {
			visiblePathIndex = -1
			drawAllPaths()
			return
		}
		visiblePathIndex -= 1
	}

	@IBAction func nextButtonTapped(_ sender: UIButton) {
		guard visiblePathIndex < knightPaths.count - 1 else {
			visiblePathIndex = knightPaths.count
			drawAllPaths()
			return
		}
		visiblePathIndex += 1
	}

	@IBAction func runButtonTapped(_ sender: UIButton) {
		showPathControls(false)
		knightPaths.removeAll()
		visiblePathIndex = 0
		chessView.resetPathLayers()

		if selectedPositions.count == 2 {
			knightPaths = ChessSolver.getKnightMoves(from: selectedPositions[0], endPosition: selectedPositions[1], for: chessView.dimentions)
			print("Found \(knightPaths.count) paths! Drawing knight paths for:\n\(knightPaths)")
			if !knightPaths.isEmpty {
				showPathControls(true)
				visiblePathIndex = 0
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

