//
//  Title.swift
//  Draughts
//
//  Created by Nikita Semenov on 30.01.2021.
//

import Foundation
import SwiftUI

// Represents Title of the window
struct LargeTitle: View {
	
	var text: String
	var fgColor: Color
	
	init(_ text: String, ofColor: Color) {
		self.text = text
		self.fgColor = ofColor
	}
	
	var body: some View {
		Text(text)
			.font(.largeTitle)
			.fontWeight(.heavy)
			.foregroundColor(fgColor)
	}
}
