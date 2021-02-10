//
//  Settings.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import Foundation

class Settings: ObservableObject {
	
	@Published var bot = false {
		didSet {
			if bot {
				boardRotation = false
			}
		}
	}
	
	@Published var boardRotation = false {
		didSet {
			if boardRotation {
				bot = false
			}
		}
	}
	
	@Published var turnTime: Int = 30
	@Published var darkMode = false
	
	class Stats: ObservableObject {
		
		@Published var gamesCount = 0
		@Published var winsCount = 0
		@Published var losesCount = 0
		@Published var tiesCount = 0
	}
	
	func setToDefault() {
		bot = false
		turnTime = 30
		boardRotation = false
		darkMode = false
	}
}
