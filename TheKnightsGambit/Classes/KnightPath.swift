//
//  KnightPath.swift
//  TheKnightsGambit
//
//  Created by Lucas Paul on 16/1/21.
//

import Foundation

/**
Represents a solution to the problem. (The 2 moves a knight can make to reach the end position)
*/
struct KnightPath: CustomStringConvertible {
	let move1: Position
	let move2: Position

	var description: String { "M1\(move1) | M2\(move2)" }

	func notation(for dimentions: Int) -> String {
		return "\(move1.getNotation(for: dimentions)) , \(move2.getNotation(for: dimentions))"
	}
}
