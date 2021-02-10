//
//  ContentView.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import SwiftUI

struct MenuView: View {
	
	@ObservedObject var settings = Settings()
	@ObservedObject var stats = Settings.Stats()
	
	@State var isGame = false
	
	// Determines what view is shown (SettingsView or StatsView)
	@State private var selectedView: Int? = 0
	
    var body: some View {
		
		NavigationView {
			ZStack {
				// Proper window condition
				if !isGame {
						
					// Back Ground Color
					Color(settings.darkMode ? "BgDark" : "BgLight").ignoresSafeArea()
					
					VStack {
						Spacer()
						
						LargeTitle("Checkers", ofColor: Color("Crown"))
							
						
						Spacer()
						
						// Start Button
						RoundedButtonToggler<Capsule>("Start",
									  fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
									  bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
									  width: 250,
									  content: $isGame)
							.padding(.bottom)
						
						// Settings Button
						RoundedButton<Capsule>("Settings",
									  fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
									  bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
									  width: 225,
									  content: { selectedView = 1 })
							.padding(.bottom)
							.background(
								// Link to Settings
								NavigationLink(
									
									destination: SettingsView(settings: settings),
									tag: 1,
									selection: $selectedView,
									label: {
										EmptyView()
									}
								)
							)
						
						// Stats Button
						RoundedButton<Capsule>("Stats",
									  fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
									  bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
									  width: 200,
									  content: { selectedView = 2 })
							.padding(.bottom)
							.background(
								// Link to Stats
								NavigationLink(
									
									destination: StatsView(settings: settings, stats: stats),
									tag: 2,
									selection: $selectedView,
									label: {
										EmptyView()
									}
								)
							)
						
						Spacer()
					}
					.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
					.animation(.easeOut)
					
				} else {
					
					GameView(settings: settings, stats: stats, isGame: $isGame)
						.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
						.animation(.easeOut)
				}
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
