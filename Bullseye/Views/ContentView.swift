//
//  ContentView.swift
//  Bullseye
//
//  Created by Darack Nanto on 4/24/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var alertIsVisible = false
    @State private var sliderValue = 50.0
    @State private var game = Game()
    
    var body: some View {
        ZStack {
            BackgroundView(game: $game)
            VStack {
                InstructionsView(game: $game)
                // Hit me button! to display popup.
                    .padding(.bottom, 100)
                HitMeButton(alertIsVisible: $alertIsVisible, sliderValue: $sliderValue, game: $game)
            }
            SliderView(sliderValue: $sliderValue)
        }
    }
}
struct InstructionsView: View {
    @Binding var game: Game
    
    var body: some View {
        VStack {
        InstructionText (text: "🎯🎯🎯\nPut the bulls eyes as close as you can to")
            .padding(.leading, 30.0)
            .padding(.trailing, 30.0)
        BigNumberText(text: String(game.target))
        }
    }
}

struct SliderView: View {
    @Binding var sliderValue: Double
    
    var body: some View {
        HStack {
            SliderLabelText(text: "1")
            Slider(value: $sliderValue, in: 1.0...100.0)
            SliderLabelText(text: "100")
        }
        .padding()
    }
}

struct HitMeButton: View {
    @Binding var alertIsVisible: Bool
    @Binding var sliderValue: Double
    @Binding var game: Game
    
    var body: some View {
            Button("Hit me".uppercased())  {
                alertIsVisible = true
            }
            .padding(20.0)
            .font(.title3)
            .background(
                ZStack {
                    Color("ButtonColor")
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                }
            )
            .foregroundColor(.white)
            .cornerRadius(21.0)
            .overlay(
                RoundedRectangle(cornerRadius: 21.0)
                    .strokeBorder(Color.white, lineWidth: 2.0)
            )
            .alert(
              "Hello there!",
              isPresented: $alertIsVisible,
              presenting: {
                let roundedValue = Int(sliderValue.rounded())
                return (
                  roundedValue,
                  game.points(sliderValue: roundedValue)
                )
              } () as (roundedValue: Int, points: Int)
            ) { data in
              Button("Awesome!") {
                game.startNewRound(points: data.points)
              }
            } message: { data in
              Text("The slider's value is \(data.roundedValue).\n" + "You scored \(data.points) points this round.")
            }
        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewLayout(.fixed(width: 568, height: 320))
        //Dark mode view portrait and landscape
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 568, height: 320))
    }
}
