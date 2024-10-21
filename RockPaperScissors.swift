import SwiftUI

// Game Over View
struct GameOverView: View {
    var yourScore: Int
    var botScore: Int

    @Environment(\.dismiss) var dismiss
    var onRestart: () -> Void

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Display win or lose message
                if yourScore == 5 {
                    Text("You Win!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    Text("You Lose...")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()

                // Restart button
                Button(action: {
                    onRestart() // Call the restart function to reset the scores
                    dismiss()   // Dismiss and go back to start a new game
                }) {
                    Text("Play Again")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
    }
}

// Result View
struct ResultView: View {
    var userChoice: String
    var botChoice: String
    var yourScore: Int
    var botScore: Int
    var tieScore: Int
    var resultMessage: String

    @Environment(\.dismiss) var dismiss

    // Helper function to convert choice to corresponding emoji
    func choiceToEmoji(choice: String) -> String {
        switch choice {
        case "rock":
            return "👊🏼"
        case "paper":
            return "✋🏼"
        case "scissors":
            return "✌🏼"
        default:
            return "❓"
        }
    }

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                // Score display
                HStack {
                    Text("Your Score: \(yourScore)")
                        .padding(.leading)
                    Spacer()
                    Text("Tie Score: \(tieScore)")
                        .padding()
                    Spacer()
                    Text("Bot Score: \(botScore)")
                        .padding(.trailing)
                }
                .padding(.top)

                Spacer()

                // Display bot's choice emoji
                Text(choiceToEmoji(choice: botChoice))
                    .font(.system(size: 100))
                    .padding(.vertical, 10)

                // Win/lose/tie result message
                Text(resultMessage)
                    .font(.title)
                    .padding(.vertical, 10)

                // Display user's choice emoji
                Text(choiceToEmoji(choice: userChoice))
                    .font(.system(size: 80))
                    .padding(.vertical, 10)

                Spacer()

                // Play again button
                Button(action: {
                    dismiss() // Dismiss and return to the first page
                }) {
                    Text("Keep Playing")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
    }
}

struct ContentView: View {
    @State private var yourScore = 0
    @State private var botScore = 0
    @State private var tieScore = 0
    @State private var userChoice = ""
    @State private var botChoice = ""
    @State private var resultMessage = ""

    @State private var isResultShown = false
    @State private var isGameOver = false

    let choices = ["rock", "paper", "scissors"]

    // Function to reset the game
    func restartGame() {
        yourScore = 0
        botScore = 0
        tieScore = 0
        userChoice = ""
        botChoice = ""
        resultMessage = ""
    }

    func playGame(yourChoice: String) {
        let botChoice = choices.randomElement() ?? "rock"
        self.botChoice = botChoice
        self.userChoice = yourChoice

        // Determine the outcome
        if yourChoice == botChoice {
            tieScore += 1
            resultMessage = "It's a tie!"
        } else if (yourChoice == "rock" && botChoice == "scissors") ||
                    (yourChoice == "paper" && botChoice == "rock") ||
                    (yourChoice == "scissors" && botChoice == "paper") {
            yourScore += 1
            resultMessage = "Your Point!"
        } else {
            botScore += 1
            resultMessage = "Bot's Point..."
        }

        // Check for game over (either score reaches 10)
        if yourScore == 5 || botScore == 5 {
            isGameOver = true
        } else {
            isResultShown = true
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()

                VStack {
                    // Score display
                    HStack {
                        Text("Your Score: \(yourScore)")
                            .padding(.leading)
                        Spacer()
                        Text("Tie Score: \(tieScore)")
                            .padding()
                        Spacer()
                        Text("Bot Score: \(botScore)")
                            .padding(.trailing)
                    }
                    .padding(.top)

                    Spacer()

                    // Display the robot emoji (before the game starts)
                    Text("🤖")
                        .font(.system(size: 100))
                        .padding(.vertical, 10)

                    // Main game title
                    Text("Rock, Paper, Scissors")
                        .font(.title)
                        .padding(.vertical, 5)
                    
                    Text("First to 5 wins!")
                        .font(.system(size:20))
                        .padding(.vertical, 10)

                    // User choices (rock, paper, scissors)
                    HStack {
                        Button(action: {
                            playGame(yourChoice: "rock")
                        }) {
                            Text("👊🏼")
                                .font(.system(size: 80))
                                .padding()
                        }
                        Button(action: {
                            playGame(yourChoice: "paper")
                        }) {
                            Text("✋🏼")
                                .font(.system(size: 80))
                                .padding()
                        }
                        Button(action: {
                            playGame(yourChoice: "scissors")
                        }) {
                            Text("✌🏼")
                                .font(.system(size: 80))
                                .padding()
                        }
                    }

                    Spacer()
                }
                .padding(.bottom)

                // Navigation to ResultView
                NavigationLink(
                    destination: ResultView(
                        userChoice: userChoice,
                        botChoice: botChoice,
                        yourScore: yourScore,
                        botScore: botScore,
                        tieScore: tieScore,
                        resultMessage: resultMessage
                    ),
                    isActive: $isResultShown
                ) {
                    EmptyView()
                }

                // Navigation to GameOverView
                NavigationLink(
                    destination: GameOverView(
                        yourScore: yourScore,
                        botScore: botScore,
                        onRestart: restartGame // Pass the restart function to reset the game
                    ),
                    isActive: $isGameOver
                ) {
                    EmptyView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
