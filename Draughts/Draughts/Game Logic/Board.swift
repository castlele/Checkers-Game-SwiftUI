//
//  Board.swift
//  Draughts
//
//  Created by Nikita Semenov on 30.01.2021.
//

import Foundation

struct Board {
	
	var array: [Node]
	
	init() {
		array = .init(repeating: Node(isWithCheck: false), count: 64)
		placeNodes()
		makePaths()
	}
	
	public func move(to node: Node, as player: Player) -> Bool {
		if let selected = findSelected() {
			if selected == node {
				select(node)
				return false
			} else {
				if selected.possibleNodesToEat.isEmpty {
					if selected.possibleNodesToMove.contains(node) {
						selected.isWithCheck = false
						selected.isAlive = false
						node.isWithCheck = true
						node.isAlive = true
						node.player = selected.player
						
						if isCanBecomeQueen(node) {
							becomeQueen(node)
						}
						if selected.isQueen {
							becomeQueen(node)
							selected.isQueen = false
						}
						
						select(selected)
						
						return true
						
					} else {
						select(selected)
						return false
					}
				} else {
					if selected.possibleNodesToEat.flatMap({ $0 }).contains(node) {
						selected.isWithCheck = false
						selected.isAlive = false
						node.isWithCheck = true
						node.isAlive = true
						node.player = selected.player
						
						if isCanBecomeQueen(node) {
							becomeQueen(node)
						}
						
						if selected.isQueen {
							becomeQueen(node)
							selected.isQueen = false
						}
						
						eate(node, selected)
						select(selected)
						
						if node.possibleNodesToEat.isEmpty {
							return true
						} else {
							select(node)
							return false
						}
						
					} else {
						if selected.possibleNodesToMove.contains(node) {
							selected.isWithCheck = false
							selected.isAlive = false
							node.isWithCheck = true
							node.isAlive = true
							node.player = selected.player
							
							if isCanBecomeQueen(node) {
								becomeQueen(node)
							}
							if selected.isQueen {
								becomeQueen(node)
								selected.isQueen = false
							}
							
							select(selected)
							
							return true
							
						} else {
							select(selected)
							return false
						}
					}
				}
			}
		} else {
			if node.player == player {
				select(node)
				return false
			} else {
				return false
			}
		}
	}
	
	private func isCanBecomeQueen(_ node: Node) -> Bool {
		switch node.player {
			case .playerA:
				return node.nextRight == nil && node.nextLeft == nil ? true : false
			case .playerB:
				return node.previousRight == nil && node.previousLeft == nil ? true : false
		}
	}
	
	private func becomeQueen(_ node: Node) {
		node.isQueen = true
	}
	
	private func eate(_ currentNode: Node, _ pastNode: Node) {
		switch currentNode.player {
			case .playerA:
				if currentNode.previousLeft?.previousLeft == pastNode {
					currentNode.previousLeft?.isWithCheck = false
					currentNode.previousLeft?.isAlive = false
					
				}
				if currentNode.previousRight?.previousRight == pastNode {
					currentNode.previousRight?.isWithCheck = false
					currentNode.previousRight?.isAlive = false
				}
				
				if currentNode.isQueen {
					if currentNode.nextLeft?.nextLeft == pastNode {
						currentNode.nextLeft?.isWithCheck = false
						currentNode.nextLeft?.isAlive = false
					}
					if currentNode.nextRight?.nextRight == pastNode {
						currentNode.nextRight?.isWithCheck = false
						currentNode.nextRight?.isAlive = false
					}
				}
				
			case .playerB:
				if currentNode.nextLeft?.nextLeft == pastNode {
					currentNode.nextLeft?.isWithCheck = false
					currentNode.nextLeft?.isAlive = false
				}
				if currentNode.nextRight?.nextRight == pastNode {
					currentNode.nextRight?.isWithCheck = false
					currentNode.nextRight?.isAlive = false
				}
				if currentNode.isQueen {
					if currentNode.previousLeft?.previousLeft == pastNode {
						currentNode.previousLeft?.isWithCheck = false
						currentNode.previousLeft?.isAlive = false
						
					}
					if currentNode.previousRight?.previousRight == pastNode {
						currentNode.previousRight?.isWithCheck = false
						currentNode.previousRight?.isAlive = false
					}
				}
		}
		
	}
	
	private func findSelected() -> Node? {
		for node in array {
			if node.isSelected {
				return node
			}
		}
		return nil
	}
	
	private func select(_ node: Node) {
		guard node.background == .black else { return }
		node.isSelected = node.isSelected ? false : true
	}
	
	private mutating func placeNodes() {
		// Top
		for index in stride(from: 1, through: 7, by: 2) {
			array[index] = Node(isWithCheck: true, bg: .black, isAlive: true)
		}
		
		for index in stride(from: 8, through: 14, by: 2) {
			array[index] = Node(isWithCheck: true, bg: .black, isAlive: true)
		}
		
		for index in stride(from: 17, through: 23, by: 2) {
			array[index] = Node(isWithCheck: true, bg: .black, isAlive: true)
		}
		
		// Middle
		for index in stride(from: 24, through: 30, by: 2) {
			array[index] = Node(bg: .black)
		}
		
		for index in stride(from: 33, through: 39, by: 2) {
			array[index] = Node(bg: .black)
		}
		
		// Bottom
		for index in stride(from: 40, through: 46, by: 2) {
			array[index] = Node(isWithCheck: true, player: .playerA, bg: .black, isAlive: true)
		}
		
		for index in stride(from: 49, through: 55, by: 2) {
			array[index] = Node(isWithCheck: true, player: .playerA, bg: .black, isAlive: true)
		}
		
		for index in stride(from: 56, through: 62, by: 2) {
			array[index] = Node(isWithCheck: true, player: .playerA, bg: .black, isAlive: true)
		}
	}
	
	private func makePaths() {
		
		var fromOdd = 1
		var toOdd = 7
		var fromEven = 8
		var toEven = 14
		
		for i in 1...8 {
			if i.isMultiple(of: 2) {
				for index in stride(from: fromEven, through: toEven, by: 2) {
					if i == 8 {
						if index != fromEven {
							array[index].nextRight = array[index - 7]
							array[index].nextLeft = array[index - 9]
							array[index].previousRight = nil
							array[index].previousLeft = nil
						} else {
							array[index].nextRight = array[index - 7]
							array[index].nextLeft = nil
							array[index].previousRight = nil
						}
					} else {
						if index != fromEven {
							array[index].nextRight = array[index - 7]
							array[index].nextLeft = array[index - 9]
							array[index].previousRight = array[index + 9]
							array[index].previousLeft = array[index + 7]
						} else {
							array[index].nextRight = array[index - 7]
							array[index].nextLeft = nil
							array[index].previousRight = array[index + 9]
							array[index].previousLeft = nil
						}
					}
				}
				fromEven += 16
				toEven += 16
				
			} else {
				for index in stride(from: fromOdd, through: toOdd, by: 2) {
					if i == 1 {
						if index != toOdd {
							array[index].previousRight = array[index + 9]
							array[index].previousLeft = array[index + 7]
						} else {
							array[index].previousLeft = array[index + 7]
							array[index].previousRight = nil
						}
						array[index].nextRight = nil
						array[index].nextLeft = nil
						
					} else {
						if index != toOdd {
							array[index].nextLeft = array[index - 9]
							array[index].nextRight = array[index - 7]
							array[index].previousRight = array[index + 9]
							array[index].previousLeft = array[index + 7]
						} else {
							array[index].nextRight = nil
							array[index].nextLeft = array[index - 9]
							array[index].previousLeft = array[index + 7]
							array[index].previousRight = nil
						}
					}
				}
				fromOdd += 16
				toOdd += 16
			}
		}
	}
	
	public subscript(_ column: Int, _ row: Int) -> Node {
		get {
			return array[8 * row + column]
		}
		
		set {
			if (8 * row + column) % 2 == 0 {
				return
			} else {
				array[8 * row + column] = newValue
			}
		}
	}
}
