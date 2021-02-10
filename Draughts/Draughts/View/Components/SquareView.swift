//
//  SquareView.swift
//  Draughts
//
//  Created by Nikita Semenov on 01.02.2021.
//

import SwiftUI

struct Square: Shape {
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		let rowSize = 43.75
		let columnSize = 43.75
		
		let rect = CGRect(x: 0, y: 0, width: columnSize, height: rowSize)
		path.addRect(rect)
		
		
		return path
	}
}

struct SquareView: View {
	
	@ObservedObject var node = Node()
	@ObservedObject var settings: Settings
	
	var body: some View {
		
		let bgColor: Color
		let checkColor: Color
		
		switch node.background {
			case .black:
				bgColor = Color(settings.darkMode ? "BoardDarkBlockDark" : "BoardDarkBlockLight")
			case .white:
				bgColor = Color(settings.darkMode ? "BoardLightBlockDark" : "BoardLightBlockLight")
		}
		
		switch node.player {
			case .playerA:
				checkColor = Color.black
			case .playerB:
				checkColor = Color.white
		}
		
		return ZStack {
			Square()
				.fill(bgColor)
				.frame(width: 44, height: 44)
			if node.isWithCheck {
				if node.isQueen {
					ZStack {
						if node.isSelected {
							Circle()
								.strokeBorder(Color.blue,lineWidth: 4)
								.background(Circle().foregroundColor(checkColor))
								.frame(width: 42, height: 42)
							
						} else {
							Circle()
								.fill(checkColor)
								.frame(width: 42, height: 42)
						}
						Image(systemName: "crown.fill").foregroundColor(Color("Crown"))
					}
				} else {
					if node.isSelected {
						Circle()
							.strokeBorder(Color.blue,lineWidth: 4)
							.background(Circle().foregroundColor(checkColor))
							.frame(width: 42, height: 42)
						
					} else {
						Circle()
							.fill(checkColor)
							.frame(width: 42, height: 42)
					}
				}
			}
		}
	}
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
		SquareView(settings: Settings())
    }
}
