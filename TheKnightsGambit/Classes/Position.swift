//
//  Position.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import Foundation

/**
Represents a position on the board
*/
struct Position: Equatable, CustomStringConvertible {
	var row: Int
	var col: Int

	var description: String { "(\(row), \(col))" }

	static func == (lhs: Position, rhs: Position) -> Bool {
		return lhs.row == rhs.row && lhs.col == rhs.col
	}

	/**
	Create a new position by moving the Knight

	- parameter by: The relative position to move the knight by.
	- returns: The final position after the move
	*/
	func move(by position: Position) -> Position {
		return Position(row: self.row + position.row, col: self.col + position.col)
	}

	/**
	Validate the move of a knight on a chessboard

	- parameter move: The move to be validated
	- parameter curPosition: The move to be validated
	- parameter boardDimentions: The size of the board
	- returns: true if the move is valid, otherwise false
	*/
	func isValidMove(boardDimentions: Int) -> Bool {
		return 0 <= self.row
			&& self.row < boardDimentions
			&& 0 <= self.col
			&& self.col < boardDimentions
	}

	/**
	Returns the algebric notation of this position, such as a1, h8, etc.

	- parameter boardDimentions: The size of the board
	- returns: the algebric notation of thios position
	*/
	func getNotation(for boardDimentions: Int) -> String {
		return "\((col).asLetter!)\((boardDimentions - row))"
	}

}
