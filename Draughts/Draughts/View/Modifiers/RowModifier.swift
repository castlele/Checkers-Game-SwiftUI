//
//  RowModifier.swift
//  Draughts
//
//  Created by Nikita Semenov on 30.01.2021.
//

import Foundation
import SwiftUI

// Represents modifier for Form and List
struct Row: ViewModifier {
	
	var fgColor: Color
	var rowColor: Color
	var font: Font
	var disabled = false
	
	func body(content: Content) -> some View {
		content
			.font(font)
			.foregroundColor(fgColor)
			.listRowBackground(rowColor)
			.disabled(disabled)
			
	}
}
