//
//  ChessSolver.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 17/1/21.
//

import Foundation

class ChessSolver {

	static let maxMoves = 3

	/** The moves that a knight can make from its current position */
	static let validKnightMoves = [
		Position(row: 2, col: 1),
		Position(row: 1, col: 2),
		Position(row: -1, col: 2),
		Position(row: -2, col: 1),
		Position(row: -2, col: -1),
		Position(row: -1, col: -2),
		Position(row: 1, col: -2),
		Position(row: 2, col: -1)
	]

	/**
	Returns the distance between the rows and columns of two Positions

	- parameter position1: The first position.
	- parameter position2: The second position.
	- returns: A tupple containing the distance of rows and columns
	*/
	static func getDistancesBetween(_ position1: Position, _ postion2: Position) -> (rowDist: Int, colDist: Int) {
		return (abs(position1.row - postion2.row), abs(position1.col - postion2.col))
	}

	/**
	Returns wether a 3 move path is possible from a starting position to an end position

	- parameter startPosition: The starting position.
	- parameter endPosition: The ending position.
	- returns: True if there is possibly a solution or false if there is not


	# Notes: #
	This method is used to avoid any uneccessary calculations on knight positions, by checking the
	user's inputs. If the starting and ending positions are of the same color (thus both even or odd)
	then the problem does not have a solution for 3 moves.
	*/
	static func checkInitialPositions(startPosition: Position, endPosition: Position) -> Bool {
		return (startPosition.row + startPosition.col).isEven != (endPosition.col + endPosition.row).isEven
	}

	/**
	This function checks the distance between two positions and returns if its possible to reach
	the endPosition, distance wise, in remaining moves.

	- parameter nextPosition: The position we want to check.
	- parameter endPosition: The end position the knight should arrive in remainingMoves.
	- parameter remainingMoves: In how many moves the knight should reach the endPosition.
	- returns: True onlt if it makes sense for the knight to try the next move, based on the distances


	# Notes: #
	1. The knight can only move 2 spaces in a given direction. This means that the max distance
	   between the position of the night and the end position should not be more than 2 * remainingMoves
	   otherwise the knight cannot reach it. This is used to eliminate positions that would move the
	   knight away from its end position.

	2. If the max distance check passes, we can check the distance between the two positions and
	   depending on if the remaining moves moves is odd (or even) and the sum of the distances is not
	   then we know that the knight cannot reach the end position in the remaining moves, thus we
	   eliminate it.
	*/
	static func checkDistanceOf(nextPosition: Position, to endPosition: Position, remainingMoves: Int) -> Bool {
		let distance = getDistancesBetween(nextPosition, endPosition)

		// Check  if the perpendicular distance between the two positions is bigger than what a knight
		// can do in the remaining moves
		guard max(distance.rowDist, distance.colDist) <= remainingMoves * 2 else { // The knight can only move 2 squares in a direction
			return false
		}

		// Finally, check if the knight can arrive at the endPosition based on the distances.
		// If the distances and the rmaining moves are both odd/even then the move is valid, otherwise it's not
		return (distance.rowDist + distance.colDist).isOdd == remainingMoves.isOdd
	}

	/**
	Returns all the possible paths a Knight can take from starting to end position in 3 moves

	- parameter startingPosition: The starting position.
	- parameter endPosition: The final position.
	- parameter boardDimentions: The dimentions of the chess board.
	- returns: An array with the paths, if any.
	*/
	static func getKnightMoves(from startingPosition: Position, endPosition: Position, for boardDimentions: Int) -> [KnightPath] {
		var solutions = [KnightPath]()

		print("Finding all paths of a Knight from \(startingPosition) to \(endPosition)...")

		// Check the initial positions before running any other calculations
		if checkInitialPositions(startPosition: startingPosition, endPosition: endPosition)
			&& checkDistanceOf(nextPosition: startingPosition, to: endPosition, remainingMoves: 3) {

			// If the start and end positions are not on the same color, proceed with the calculations
			for move1 in validKnightMoves { // Move #1
				let position1 = startingPosition.move(by: move1)
				if position1.isValidMove(boardDimentions: boardDimentions)
					&& checkDistanceOf(nextPosition: position1, to: endPosition, remainingMoves: 2) {

					for move2 in validKnightMoves { // Move #2
						let position2 = position1.move(by: move2)
						if position2.isValidMove(boardDimentions: boardDimentions)
							&& checkDistanceOf(nextPosition: position2, to: endPosition, remainingMoves: 1) {

							for move3 in validKnightMoves { // Move #3
								let position3 = position2.move(by: move3)
								if position3 == endPosition {
									solutions.append(KnightPath(move1: position1, move2: position2))
								}
							}
						}
					}
				}
			}
		} else {
			print("There is no path for the knight in 3 moves from \(startingPosition) to \(endPosition)")
		}

		return solutions
	}

}
