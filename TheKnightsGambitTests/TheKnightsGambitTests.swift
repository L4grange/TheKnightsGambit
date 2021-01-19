//
//  TheKnightsGambitTests.swift
//  TheKnightsGambitTests
//
//  Created by Lucas Paul on 16/1/21.
//

import XCTest
@testable import TheKnightsGambit

class TheKnightsGambitTests: XCTestCase {

	var boardDimentions = 8

    override func setUpWithError() throws {
        boardDimentions = 8
    }

	// MARK: - Position Tests
	func testPositionEquals() {
		let position1 = Position(row: 7, col: 2)
		let position2 = Position(row: 7, col: 2)
		let position3 = Position(row: 3, col: 2)

		XCTAssertEqual(position1 == position2, true, "Positions should be equal")
		XCTAssertEqual(position2 == position1, true, "Positions should be equal")
		XCTAssertEqual(position2 == position3, false, "Positions should not be equal")
		XCTAssertEqual(position3 == position2, false, "Positions should not be equal")
		XCTAssertEqual(position1 == position3, false, "Positions should not be equal")
		XCTAssertEqual(position3 == position1, false, "Positions should not be equal")
	}

	func testMoveBy() {
		let position = Position(row: 7, col: 2)
		let move1 = Position(row: 1, col: 1)
		let move2 = Position(row: 3, col: 2)

		XCTAssertEqual(position.move(by: move1), Position(row: 8, col: 3), "Move was invalid")
		XCTAssertEqual(position.move(by: move2), Position(row: 10, col: 4), "Move was invalid")
		XCTAssertNotEqual(position.move(by: move2), Position(row: 3, col: 3), "Move should not be equal with the test Position")
	}

	func testPositionIsValid() {
		boardDimentions = 8
		let position = Position(row: 7, col: 2)
		XCTAssertEqual(position.isValidMove(boardDimentions: boardDimentions), true, "Position is valid for \(boardDimentions)")

		boardDimentions = 6
		XCTAssertEqual(position.isValidMove(boardDimentions: boardDimentions), false, "Position is not valid for \(boardDimentions)")
	}

	func testPositionNotation() {
		boardDimentions = 8
		let position1 = Position(row: 0, col: 0)
		let position2 = Position(row: 7, col: 0)
		let position3 = Position(row: 2, col: 1)
		let position4 = Position(row: 5, col: 6)
		let position5 = Position(row: 0, col: 7)
		let position6 = Position(row: 7, col: 7)

		XCTAssertEqual(position1.getNotation(for: boardDimentions), "a8", "Notation for \(position1) should be a8")
		XCTAssertEqual(position2.getNotation(for: boardDimentions), "a1", "Notation for \(position2) should be a1")
		XCTAssertEqual(position3.getNotation(for: boardDimentions), "b6", "Notation for \(position3) should be b6")
		XCTAssertEqual(position4.getNotation(for: boardDimentions), "g3", "Notation for \(position4) should be g3")
		XCTAssertEqual(position5.getNotation(for: boardDimentions), "h8", "Notation for \(position5) should be h8")
		XCTAssertEqual(position6.getNotation(for: boardDimentions), "h1", "Notation for \(position6) should be h1")
	}


	// MARK: - Chess Solver Tests

	func testSolverGetDistances() {
		let startPosition = Position(row: 1, col: 3)
		let endPosition = Position(row: 7, col: 2)

		let distances = ChessSolver.getDistancesBetween(startPosition, endPosition)
		XCTAssertEqual(distances.rowDist, 6, "Row distance should be 6.")
		XCTAssertEqual(distances.colDist, 1, "Col distance should be 1.")
	}

	func testSolverCheckInitialPositionsSuccess() {
		let startPosition = Position(row: 1, col: 3)
		let endPosition = Position(row: 7, col: 2)

		let hasSolutions = ChessSolver.checkInitialPositions(startPosition: startPosition, endPosition: endPosition)
		XCTAssertEqual(hasSolutions, true, "The position pair should have solutions")

		let solutions = ChessSolver.getKnightMoves(from: startPosition, endPosition: endPosition, for: boardDimentions)

		XCTAssertNotEqual(solutions.isEmpty, hasSolutions, "The position pair should have solutions.")
	}

	func testSolverCheckInitialPositionsFailure() {
		let startPosition = Position(row: 1, col: 3)
		let endPosition = Position(row: 7, col: 3)

		let hasSolutions = ChessSolver.checkInitialPositions(startPosition: startPosition, endPosition: endPosition)
		XCTAssertEqual(hasSolutions, false, "The position pair should not have solutions")

		let solutions = ChessSolver.getKnightMoves(from: startPosition, endPosition: endPosition, for: boardDimentions)

		XCTAssertNotEqual(solutions.isEmpty, hasSolutions, "The position pair should not have solutions.")
	}

	func testSolverUnsolvablePositions() {
		let startPosition = Position(row: 3, col: 3)
		let endPosition = Position(row: 4, col: 4)

		let solutions = ChessSolver.getKnightMoves(from: startPosition, endPosition: endPosition, for: boardDimentions)

		XCTAssertEqual(solutions.count, 0, "There should be no solutions.")
	}

	func testSolverUnsolvablePositionsDistanceTooFar() {
		let startPosition = Position(row: 0, col: 2)
		let endPosition = Position(row: 7, col: 5)

		let solutions = ChessSolver.getKnightMoves(from: startPosition, endPosition: endPosition, for: boardDimentions)

		XCTAssertEqual(solutions.count, 0, "There should be no solutions.")
	}

	func testSolverCornerSolutions() {
		let startPosition = Position(row: 7, col: 6)
		let endPosition = Position(row: 7, col: 7)

		let solutions = ChessSolver.getKnightMoves(from: startPosition, endPosition: endPosition, for: boardDimentions)

		XCTAssertEqual(solutions.count, 2, "There should 2 solutions.")
	}

	// MARK: - Extensions Tests
	func testEvenOddNumbers() {
		XCTAssertEqual(2.isEven, true, "2 should be even, don't you think?")
		XCTAssertEqual(2.isOdd, false, "2 should not be odd, right?")
		XCTAssertEqual(7.isOdd, true, "7 should be odd, right?")
		XCTAssertEqual((152 + 17).isOdd, true, "\(152 + 17) should be odd!")
	}

}
