//
//  GameVIew.swift
//  Draughts
//
//  Created by Nikita Semenov on 29.01.2021.
//

import SwiftUI

struct GameView: View {
	
	@ObservedObject var settings: Settings
	@ObservedObject var stats: Settings.Stats
	
	@Binding var isGame: Bool
	// Represents context menu while quiting to MenuView
	@State private var isWantToQuit = false
	// Represents sheet with SettingsView
	@State private var isSheet = false
	// Pause state of current view
	@State private var isPause = false
	
	@State private var board = Board()
	@State private var player: Player = .playerA
	@State private var timeRemaining = 30
	
	@State private var isWin = false
	@State private var steps = 0
	
	var gameWonBy: Player? {
		var playerB = 0
		var playerA = 0
		
		for node in board.array {
			if node.isWithCheck && node.player == .playerB && node.isAlive {
				playerB += 1
			}
			if node.isWithCheck && node.player == .playerA && node.isAlive {
				playerA += 1
			}
		}
		
		if playerB == 0 {
			return .playerA
		}
		
		if  playerA == 0 {
			return .playerB
		}
		
		return nil
	}
	
	var turnTime: Int {
		timeRemaining = settings.turnTime
		return timeRemaining
	}
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
    var body: some View {
		if isGame {
			ZStack {
			// Back Ground Color
			Color(settings.darkMode ? "BgDark" : "BgLight").ignoresSafeArea()
			
				VStack {
					Spacer()
					
					HStack {
						LargeTitle("\(timeRemaining)", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight")).padding()
							.onReceive(timer) { _ in
								if timeRemaining > 0 {
									timeRemaining -= 1
								}
								if timeRemaining == 0 {
									player = player == .playerA ? .playerB : .playerA
									timeRemaining = turnTime
								}
								if isPause {
									timeRemaining -= 0
								}
							}
						
						//  Represents current player
						LargeTitle("Turn of \(player.rawValue)", ofColor: Color(settings.darkMode ? "TextDark" : "TextLight")).padding()

						// Pause button
						Button(action: {
							isPause.toggle()
							
						}, label: {
							Image(systemName: "pause.fill")
								.font(.title)
								.foregroundColor(Color(settings.darkMode ? "TextDark" : "TextLight"))
								.frame(width: 45, height: 45)
								.background(Color(settings.darkMode ? "ButtonDark" : "ButtonLight"))
								.clipShape(RoundedRectangle(cornerRadius: 10))
						})
						.padding()
					}
					
					
					
					Spacer()
					
					// Board view
					VStack(spacing: 0) {
						ForEach(0..<8) { row in
							HStack(spacing: 0) {
								ForEach(0..<8) { column in
									SquareView(node: board[column, row], settings: settings)
										.gesture(
											TapGesture()
												.onEnded { _ in
													if board.move(to: board[column, row], as: player) {
														player = player == .playerA ? .playerB : .playerA
														timeRemaining = turnTime
														steps += 1
														
														if steps == 100 {
															stats.tiesCount += 1
															isWin.toggle()
														}
														
														if let winner = gameWonBy {
															stats.gamesCount += 1
															stats.winsCount += winner == .playerA ?  1 : 0
															stats.losesCount += winner == .playerB ? 1 : 0
															isWin.toggle()
														}
													}
												}
										)
								}
							}
						}
					}.animation(.linear)
					.rotationEffect(.degrees(player == .playerB ? settings.boardRotation ? 180 : 0 : 0)).animation(.easeIn(duration: 0.6))
					
					Spacer(minLength: 50)
				}
				.blur(radius: isPause ? 10 : 0)
				.disabled(isPause ? true : false)
				.alert(isPresented: $isWin) {
					Alert(title: Text(steps == 100 ? "TIE!" : "Game was won \(gameWonBy!.rawValue)!"),
						  message: Text("Play again?"), primaryButton: .default(Text("Yes"), action: { board = Board(); timeRemaining = turnTime; steps = 0 }),
						  secondaryButton: .default(Text("No"), action: { isGame.toggle() }))
				}
				
				if isPause {
					
					// Pause Menu
					VStack {
						// Continue Button
						RoundedButtonToggler<Capsule>("Continue",
													  fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
													  bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
													  width: 180,
													  hight: 40,
													  content: $isPause).padding(.bottom)
							
						// Restart Button
						RoundedButton<Capsule>("Restart",
											   fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
											   bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
											   width: 180,
											   hight: 40,
											   content: { board = Board(); isPause.toggle(); timeRemaining = turnTime; steps = 0 }).padding(.bottom)
						
						// Settings Button
						RoundedButtonToggler<Capsule>("Settings",
											   fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
											   bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
											   width: 180,
											   hight: 40,
											   content: $isSheet).padding(.bottom)
							
						
						// Menu Button
						RoundedButtonToggler<Capsule>("Menu",
													  fgColor: Color(settings.darkMode ? "TextDark" : "TextLight"),
													  bgColor: Color(settings.darkMode ? "ButtonDark" : "ButtonLight"),
													  width: 180,
													  hight: 40,
													  content: $isWantToQuit)
					}
					.alert(isPresented: $isWantToQuit) {
						Alert(title: Text("Comeback to main menu?"),
							  message: Text("Your progress won't be saved"),
							  primaryButton: .default(Text("Yes"), action: { isGame.toggle() }),
							  secondaryButton: 	.default(Text("No")))
					}
					.sheet(isPresented: $isSheet) {
						SettingsView(settings: settings, fromGame: true)
					}
				}
			}.ignoresSafeArea()
		}
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
		GameView(settings: Settings(), stats: Settings.Stats(), isGame: .constant(true))
    }
}
