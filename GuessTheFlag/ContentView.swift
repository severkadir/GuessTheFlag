//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kadir Sever on 15.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Russia", "US", "Monaco"].shuffled()
    
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var questionNumber = 0
    
    
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            // flag was tapped
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your Score is \(score)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
            scoreTitle += "\nThe correct flag is \(countries[correctAnswer])."
        }
     
        if questionNumber == 8{
            scoreTitle = "Game Over"
            showingScore = true
        } else {
            questionNumber += 1
            showingScore = true
        }
    }
    
    func askQuestion() {
        
        if questionNumber == 8 {
                // Oyun bittiğinde kullanıcıya yeniden başlamak isteyip istemediğini sorar
                let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score). Do you want to play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    resetGame()
                }))
                ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(ac, animated: true)
                }
            } else {
                countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
            }
    }
    
    func resetGame() {
        score = 0
        questionNumber = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

#Preview {
    ContentView()
}
