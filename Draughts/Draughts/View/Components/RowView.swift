//
//  RowView.swift
//  Draughts
//
//  Created by Nikita Semenov on 30.01.2021.
//

import SwiftUI

struct RowView: View {
	
	var image: String?
	var text: String
	var info: String
	
    var body: some View {
		HStack {
			if let image = image {
				Text(image)
			}
			Text(text)
			Spacer()
			Text(info)
		}
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
		RowView(image: "👑", text: "Wins", info: "10")
    }
}
