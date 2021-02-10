//
//  RoundedButton.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import SwiftUI

struct RoundedButtonToggler<Shape>: View where Shape: SwiftUI.Shape {
	
	var text: String
	var isSystemImage: Bool
	var fgColor: Color
	var bgColor: Color
	var width: CGFloat
	var hight: CGFloat
	var shape: Shape
	@Binding var viewToggler: Bool
	
	init(_ heading: String, isSystemImage: Bool = false, fgColor: Color, bgColor: Color, width: CGFloat = 100, hight: CGFloat = 60, shape: Shape = Capsule() as! Shape, content: Binding<Bool>) {
		self.text = heading
		self.isSystemImage = isSystemImage
		self.fgColor = fgColor
		self.bgColor = bgColor
		self.width = width
		self.hight = hight
		self.shape = shape
		self._viewToggler = content
	}
	
    var body: some View {
			Button(action: {
				withAnimation(.easeOut(duration: 0.3)) {
					viewToggler.toggle()
				}
				
			}, label: {
				if isSystemImage {
					Image(systemName: text)
						.font(.title)
				} else {
					Text(text)
						.font(.title)
						.fontWeight(.medium)
				}
				
			})
			.foregroundColor(fgColor)
			.frame(width: width, height: hight)
			.background(bgColor)
			.clipShape(shape)
	}
}

struct RoundedButton<Shape>: View where Shape: SwiftUI.Shape {
	
	var text: String
	var fgColor: Color
	var bgColor: Color
	var width: CGFloat
	var hight: CGFloat
	var shape: Shape
	var action: () -> Void
	
	init?(_ heading: String, fgColor: Color, bgColor: Color, width: CGFloat = 100, hight: CGFloat = 60, shape: Shape = Capsule() as! Shape, content: @escaping () -> Void) {
		self.text = heading
		self.fgColor = fgColor
		self.bgColor = bgColor
		self.width = width
		self.hight = hight
		self.shape = shape
		self.action = content
	}
	
	var body: some View {
		Button(action: {
			action()
			
		}, label: {
			Text(text)
				.font(.title)
				.fontWeight(.medium)
		})
		.foregroundColor(fgColor)
		.frame(width: width, height: hight)
		.background(bgColor)
		.clipShape(shape)
	}
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
		RoundedButtonToggler<Capsule>("Start", fgColor: .black, bgColor: Color("BgLight"), content: .constant(false))
    }
}
