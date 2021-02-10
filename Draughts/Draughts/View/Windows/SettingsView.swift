//
//  SettingsView.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import SwiftUI

struct SettingsView: View {
	
	@ObservedObject var settings: Settings
	
	@Environment(\.presentationMode) var presentationMode
	
	var fromGame = false
	
    var body: some View {
		NavigationView {
			ZStack {
				// Back Ground Color
				Color(settings.darkMode ? "BgDark" : "BgLight")
				
				VStack {
					
					Form {
						// Choose the bot as opponent
						Section {
							Toggle("Bot as opponent", isOn: $settings.bot)
						}
						.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
								  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
								  font: Font.system(.body).weight(.bold),
								  disabled: settings.boardRotation ? true : false)
						
						
						// Toggle board rotation
						Section {
							Toggle("Desk rotation", isOn: $settings.boardRotation)
						}
						.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
								  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
								  font: Font.system(.body).weight(.bold),
								  disabled: settings.bot ? true : false)
						
						// Toggle dark mode
						Section {
							Toggle("Dark mode", isOn: $settings.darkMode)
						}
						.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
								  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
								  font: Font.system(.body).weight(.bold))
						
						// Choose turn time
						Section {
							Stepper("Turn time: \(settings.turnTime) sec.", onIncrement: {
								if settings.turnTime < 300 {
									settings.turnTime += 10
								}
								
							}, onDecrement: {
								if settings.turnTime > 0 {
									settings.turnTime -= 10
								}
							})
							.accentColor(.green)
						}
						.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
								  rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
								  font: Font.system(.body).weight(.bold))
						
						// Set all settings to default
						Section {
							HStack {
								Spacer()
								
								Button(action: {
									settings.setToDefault()
									
								}, label: {
									Text("Set to default")
								})
								
								Spacer()
							}
						}.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
								   rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
								   font: Font.system(.body).weight(.heavy))
						
						// Section enables when view was invoked from the GameView
						if fromGame {
							Section {
								HStack {
									Spacer()
									
									// State when settings were invoked from the GameView
									Button(action: {
										presentationMode.wrappedValue.dismiss()
										
									}, label: {
										Text("Back")
									})
									
									Spacer()
								}
							}.rowStyle(fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
									   rowColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
									   font: Font.system(.body).weight(.heavy))
						}
					}
					.foregroundColor(Color(settings.darkMode ? "TextDark" : "TextLight"))
					.onAppear {
						UITableView.appearance().backgroundColor = .clear
					}
				}
			}
			.ignoresSafeArea()
			.toolbar {
				ToolbarItem(placement: .principal) {
					// Custom title at the NavigationView
					LargeTitle("Settings", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight"))
				}
			}
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(settings: Settings())
    }
}
