//
//  Player.swift
//  Draughts
//
//  Created by Nikita Semenov on 30.01.2021.
//

import Foundation
import SwiftUI

enum CheckType {
	case white, queenWhite
	case black, queenBlack
}

// Represents background of the square
enum Background {
	case white, black
}

enum Player: String {
	case playerA = "Black", playerB = "White"
}

// Types of moves
enum Move {
	case nextR, nextL
	case prevR, prevL
}

class Node: ObservableObject, Identifiable, Equatable {
	
	let id = UUID()
	@Published var isWithCheck: Bool
	@Published var player: Player
	@Published var nextRight: Node?
	@Published var nextLeft: Node?
	@Published var previousRight: Node?
	@Published var previousLeft: Node?
	@Published var background: Background
	@Published var isSelected: Bool
	@Published var isQueen: Bool
	@Published var isAlive: Bool
	
	init(isWithCheck: Bool = false, player: Player = .playerB, nextR: Node? = nil, nextL: Node? = nil, prevR: Node? = nil, prevL: Node? = nil, bg: Background = .white, isSelected: Bool = false, isQueen: Bool = false, isAlive: Bool = false) {
		self.isWithCheck = isWithCheck
		self.player = player
		self.nextRight = nextR
		self.nextLeft = nextL
		self.previousRight = prevR
		self.previousLeft = prevL
		self.background = bg
		self.isSelected = isSelected
		self.isQueen = isQueen
		self.isAlive = isAlive
	}
	
	var checkType: CheckType {
		switch player {
			case .playerA:
				return isQueen ? .queenBlack : .black
			case .playerB:
				return isQueen ? .queenWhite : .white
		}
	}
	
	var possibleNodesToMove: [Node] {
		var moves = [Node]()
		switch checkType {
			case .black:
				if let nextR = findNodeToMove(.nextR) {
					moves.append(nextR)
				}
				if let nextL = findNodeToMove(.nextL) {
					moves.append(nextL)
				}
			case .white:
				if let prevR = findNodeToMove(.prevR) {
					moves.append(prevR)
				}
				if let prevL = findNodeToMove(.prevL) {
					moves.append(prevL)
				}
				
			case .queenBlack, .queenWhite:
				if let nextR = findNodeToMove(.nextR) {
					moves.append(nextR)
				}
				if let nextL = findNodeToMove(.nextL) {
					moves.append(nextL)
				}
				if let prevR = findNodeToMove(.prevR) {
					moves.append(prevR)
				}
				if let prevL = findNodeToMove(.prevL) {
					moves.append(prevL)
				}
		}
		return moves
	}
	
	var possibleNodesToEat: [[Node]] {
		var r = [[Node]]()
		
		switch checkType {
			case .black:
				if !findNodeToEat(from: self, to: .nextR).isEmpty {
					r.append(findNodeToEat(from: self, to: .nextR))
				}
				if !findNodeToEat(from: self, to: .nextL).isEmpty {
					r.append(findNodeToEat(from: self, to: .nextL))
				}
			case .white:
				if !findNodeToEat(from: self, to: .prevR).isEmpty {
					r.append(findNodeToEat(from: self, to: .prevR))
				}
				if !findNodeToEat(from: self, to: .prevL).isEmpty {
					r.append(findNodeToEat(from: self, to: .prevL))
				}
			case .queenBlack, .queenWhite:
				if !findNodeToEat(from: self, to: .prevR).isEmpty {
					r.append(findNodeToEat(from: self, to: .prevR))
				}
				if !findNodeToEat(from: self, to: .prevL).isEmpty {
					r.append(findNodeToEat(from: self, to: .prevL))
				}
				if !findNodeToEat(from: self, to: .nextR).isEmpty {
					r.append(findNodeToEat(from: self, to: .nextR))
				}
				if !findNodeToEat(from: self, to: .nextL).isEmpty {
					r.append(findNodeToEat(from: self, to: .nextL))
				}
		}
		return r
	}
	
	static func ==(lhs: Node, rhs: Node) -> Bool {
		return lhs.id == rhs.id
	}
	
	private func findNodeToEat(from node: Node, to move: Move) -> [Node] {
		var r = [Node]()
		
		switch move {
			case .nextR:
				// Unwrap optional
				if let nextR = node.nextRight {
					// Is next node occupied with enemy's check
					if nextR.isWithCheck && nextR.player != player {
						if nextR.nextRight != nil && nextR.nextRight!.isWithCheck  {
							break
						} else {
							if let nextRNext = nextR.nextRight {
								r.append(nextRNext)
								r.append(contentsOf: findNodeToEat(from: nextRNext, to: .nextR))
								r.append(contentsOf: findNodeToEat(from: nextRNext, to: .nextL))
								
								if nextRNext.checkType == .queenWhite || nextRNext.checkType == .queenBlack {
									r.append(contentsOf: findNodeToEat(from: nextRNext, to: .prevL))
								}
							} else {
								break
							}
						}
					}
				}
			case .nextL:
				// Unwrap optional
				if let nextL = node.nextLeft {
					// Is next node occupied with enemy's check
					if nextL.isWithCheck && nextL.player != player {
						if nextL.nextLeft != nil && nextL.nextLeft!.isWithCheck  {
							break
						} else {
							if let nextLNext = nextL.nextLeft {
								r.append(nextLNext)
								r.append(contentsOf: findNodeToEat(from: nextLNext, to: .nextR))
								r.append(contentsOf: findNodeToEat(from: nextLNext, to: .nextL))
								
								if nextLNext.checkType == .queenWhite || nextLNext.checkType == .queenBlack {
									r.append(contentsOf: findNodeToEat(from: nextLNext, to: .prevR))
								}
							} else {
								break
							}
						}
					}
				}
			default:
				r.append(contentsOf: findNodeToEatForQueen(from: node, to: move))
		}
		
		return r.flatMap { $0 }.compactMap { $0 }
	}
	
	private func findNodeToEatForQueen(from node: Node, to move: Move) -> [Node] {
		var r = [Node]()
		
		switch move {
			case .prevR:
				// Unwrap optional
				if let prevR = node.previousRight {
					// Is next node occupied with enemy's check
					if prevR.isWithCheck && prevR.player != player {
						if prevR.previousRight != nil && prevR.previousRight!.isWithCheck  {
							break
						} else {
							if let prevRP = prevR.previousRight {
								r.append(prevRP)
								r.append(contentsOf: findNodeToEat(from: prevRP, to: .nextR))
								r.append(contentsOf: findNodeToEat(from: prevRP, to: .nextL))
								
								if prevRP.checkType == .queenWhite || prevRP.checkType == .queenBlack {
									r.append(contentsOf: findNodeToEat(from: prevRP, to: .prevR))
								}
							} else {
								break
							}
						}
					}
				}
			case .prevL:
				// Unwrap optional
				if let prevL = node.previousLeft {
					// Is next node occupied with enemy's check
					if prevL.isWithCheck && prevL.player != player {
						if prevL.previousLeft != nil && prevL.previousLeft!.isWithCheck  {
							break
						} else {
							if let prevLP = prevL.previousLeft {
								r.append(prevLP)
								r.append(contentsOf: findNodeToEat(from: prevLP, to: .nextR))
								r.append(contentsOf: findNodeToEat(from: prevLP, to: .nextL))
								
								if prevLP.checkType == .queenWhite || prevLP.checkType == .queenBlack {
									r.append(contentsOf: findNodeToEat(from: prevLP, to: .prevR))
								}
							} else {
								break
							}
						}
					}
				}
			default:
				break
		}
		return r.flatMap { $0 }.compactMap { $0 }
	}
	
	private func findNodeToMove(_ move: Move) -> Node? {
		switch move {
			case .nextR:
				// Unwrap optional
				if let nextR = nextRight {
					// Is next node occupied
					if nextR.isWithCheck {
						// Is next node occupied with enemy player's check
						if nextR.player != player {
							// Unwrap optional
							if let nextRN = nextR.nextRight {
								// Is node after enemy's check is free
								if !nextRN.isWithCheck {
									return nextRN
								} else {
									return nil
								}
							} else {
								return nil
							}
							
						} else {
							return nil
						}
					} else {
						return nextR
					}
				}
				
			case .nextL:
				// Unwrap optional
				if let nextL = nextLeft {
					// Is next node occupied
					if nextL.isWithCheck {
						// Is next node occupied with enemy player's check
						if nextL.player != player {
							// Unwrap optional
							if let nextLN = nextL.nextLeft {
								// Is node after enemy's check is free
								if !nextLN.isWithCheck {
									return nextLN
								} else {
									return nil
								}
							} else {
								return nil
							}
							
						} else {
							return nil
						}
					} else {
						return nextL
					}
				}
				
			default:
				return findNodeToMoveForQueen(move)
		}
		
		return nil
	}
	
	private func findNodeToMoveForQueen(_ move: Move) -> Node? {
		switch move {
			case .prevR:
				// Unwrap optional
				if let prevR = previousRight {
					// Is next node occupied
					if prevR.isWithCheck {
						// Is next node occupied with enemy player's check
						if prevR.player != player {
							// Unwrap optional
							if let prevRP = prevR.previousRight {
								// Is node after enemy's check is free
								if !prevRP.isWithCheck {
									return prevRP
								} else {
									return nil
								}
							} else {
								return nil
							}
							
						} else {
							return nil
						}
					} else {
						return prevR
					}
				}
				
			case .prevL:
				if let prevL = previousLeft {
					// Is next node occupied
					if prevL.isWithCheck {
						// Is next node occupied with enemy player's check
						if prevL.player != player {
							// Is node after enemy's check is free
							// Unwrap optional
							if let prevLP = prevL.previousLeft {
								if !prevLP.isWithCheck {
									return prevLP
								} else {
									return nil
								}
							} else {
								return nil
							}
							
						} else {
							return nil
						}
					} else {
						return prevL
					}
				}
				
			default:
				return nil
		}
		return nil
	}
}
