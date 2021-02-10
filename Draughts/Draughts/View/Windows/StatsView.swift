//
//  StatsView.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import SwiftUI

struct StatsView: View {
	
	@ObservedObject var settings: Settings
	@ObservedObject var stats: Settings.Stats
	
    var body: some View {
		NavigationView {
			ZStack {
				// Back Ground Color
				Color(settings.darkMode ? "BgDark" : "BgLight")
				
				Form {
					Section {
						VStack {
							
							RowView(image: "",
									text: "Games played",
									info: "\(stats.gamesCount)")
							
							Divider()
							
							RowView(image: "👑",
									text: "Wins",
									info: "\(stats.winsCount)")
							
							Divider()
							
							RowView(image: "☠️",
									text: "Loses",
									info: "\(stats.losesCount)")
							
							Divider()
							
							RowView(image: "😐",
									text: "Ties",
									info: "\(stats.tiesCount)")
						}
						.padding()
					}
					.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
							  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"), font: Font.system(.title2).weight(.bold))
				}
			}
			.ignoresSafeArea()
			.onAppear {
				UITableView.appearance().backgroundColor = .clear
			}
			// Custom title at the NavigationView
			.toolbar {
				ToolbarItem(placement: .principal) {
					LargeTitle("Stats", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight"))
				}
			}
		}
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
		StatsView(settings: Settings(), stats: Settings.Stats())
    }
}
