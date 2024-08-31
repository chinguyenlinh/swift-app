import SwiftUI

struct GameView: View {
    let difficulty: String
    let username: String
    @State private var user: User?
    @State private var showingGameSettings = false
    @State private var navigateToDashboard = false // State to handle navigation

    @State private var hiddenColors: [Color] = []
    @State private var guessColors: [Color] = []
    @State private var revealHiddenColors = false
    @State private var score: Int = 0
    @State private var resultMessage: String = "None"
    @State private var winRate: Double = 0.0
    
    @State private var gameHistory: [GameHistory] = []
    @StateObject private var userManager = UserManager()

    let availableColors: [Color]
    let gridColumns: [GridItem]
    
    init(difficulty: String, username: String) {
        self.difficulty = difficulty
        self.username = username
        
        // Configure available colors and grid columns based on difficulty
        switch difficulty {
        case "easy":
            availableColors = [.cyan, .blue]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible())] // 2 columns
        case "medium":
            availableColors = [.red, .orange, .yellow]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 3 columns
        case "hard":
            availableColors = [.purple, .green, .cyan, .blue]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 4 columns
        default:
            availableColors = [.cyan, .blue]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible())] // Default to 2 columns
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Difficulty: \(difficulty.capitalized)")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                // Hidden blocks (top layer)
                LazyVGrid(columns: gridColumns, spacing: 10) {
                    ForEach(hiddenColors.indices, id: \.self) { index in
                        ColorBlockView(color: revealHiddenColors ? hiddenColors[index] : .gray) // Reveal color if applicable
                    }
                }
                .padding(.bottom, 20)
                
                // Guess blocks (bottom layer)
                LazyVGrid(columns: gridColumns, spacing: 10) {
                    ForEach(guessColors.indices, id: \.self) { index in
                        ColorPickerBlockView(selectedColor: $guessColors[index], availableColors: availableColors)
                    }
                }
                .padding(.bottom, 20)
                
                // Check Button
                Button(action: {
                    revealHiddenColors = true // Reveal hidden colors when checking
                    calculateScore() // Calculate the score and win rate based on guesses
                    saveGameHistory() // Save the game result
                    showingGameSettings = true
                }) {
                    Text("Check")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert(isPresented: $showingGameSettings) {
                    Alert(
                        title: Text("Result"),
                        message: Text("\(resultMessage)\nScore: \(score)\nWin Rate: \(winRate, specifier: "%.2f")"),
                        dismissButton: .default(Text("OK")) {
                            // Navigate to DashboardView after dismissing the alert
                            navigateToDashboard = true
                        }
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Game")
            .navigationDestination(isPresented: $navigateToDashboard) {
                DashboardView(username: username)
            }
            .onAppear {
                setupGame()
            }
        }
    }
    
    private func setupGame() {
        // Determine the number of blocks based on difficulty
        let blockCount: Int
        switch difficulty {
        case "easy":
            blockCount = 4 // 2 hidden blocks, 2 guess blocks
        case "medium":
            blockCount = 6 // 3 hidden blocks, 3 guess blocks
        case "hard":
            blockCount = 8 // 4 hidden blocks, 4 guess blocks
        default:
            blockCount = 4
        }
        
        // Generate random hidden colors
        hiddenColors = availableColors.shuffled().prefix(blockCount / 2).map { $0 }
        guessColors = Array(repeating: .clear, count: blockCount / 2)
    }
    
    private func checkResult() -> (correctGuesses: Int, resultMessage: String) {
        // Compare guessed colors with hidden colors
        let correctGuesses = zip(guessColors, hiddenColors).filter { $0 == $1 }.count
        let resultMessage: String
        
        if correctGuesses == hiddenColors.count {
            resultMessage = "Great"
        } else if correctGuesses > 0 {
            resultMessage = "Almost There"
        } else {
            resultMessage = "Try Again"
        }
        
        return (correctGuesses, resultMessage)
    }
    
    private func calculateScore() {
        let (correctGuesses, message) = checkResult()
        resultMessage = message
        
        // Score calculation based on difficulty
        let difficultyMultiplier: Int
        switch difficulty {
        case "easy":
            difficultyMultiplier = 1
        case "medium":
            difficultyMultiplier = 2
        case "hard":
            difficultyMultiplier = 3
        default:
            difficultyMultiplier = 1
        }
        
        score = correctGuesses * difficultyMultiplier
        winRate = Double(correctGuesses) / Double(hiddenColors.count)
    }

    private func saveGameHistory() {
        guard let user = userManager.getUser(username: username) else { return }
        
        let newGameID = user.history.count + 1
        
        let newGame = GameHistory(
            id: newGameID,
            difficulty: difficulty,
            blocks: guessColors.map { colorName($0) },
            target: hiddenColors.map { colorName($0) },
            result: resultMessage,
            winRate: winRate,
            score: score
        )
        
        var updatedUser = user
        updatedUser.history.append(newGame)
        userManager.addUser(updatedUser)
        updateUserData()
    }

    private func colorName(_ color: Color) -> String {
        switch color {
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .cyan: return "Cyan"
        case .blue: return "Blue"
        case .purple: return "Purple"
        default: return "Unknown"
        }
    }
    
    private func updateUserData() {
        if var user = userManager.getUser(username: username) {
            // Update user statistics
            user.totalScore += score
            user.numGame += 1
            user.winRate = calculateNewWinRate(for: user)

            // Save updated user data
            userManager.addUser(user)
        }
    }

    private func calculateNewWinRate(for user: User) -> Double {
        let totalGames = Double(user.numGame)
        let totalCorrectGuesses = user.history.filter { $0.result == "Great" }.count
        return totalGames > 0 ? (Double(totalCorrectGuesses) / totalGames) : 0.0
    }

}

struct ColorBlockView: View {
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 50, height: 50)
            .cornerRadius(5)
    }
}

struct ColorPickerBlockView: View {
    @Binding var selectedColor: Color
    let availableColors: [Color]
    
    var body: some View {
        Menu {
            ForEach(availableColors, id: \.self) { color in
                Button(action: {
                    selectedColor = color
                }) {
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                        Text(colorName(color))
                    }
                }
            }
        } label: {
            Rectangle()
                .fill(selectedColor == .clear ? Color.gray.opacity(0.2) : selectedColor)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
        }
    }

    private func colorName(_ color: Color) -> String {
        switch color {
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .cyan: return "Cyan"
        case .blue: return "Blue"
        case .purple: return "Purple"
        default: return "Unknown"
        }
    }
}

#Preview {
    GameView(difficulty: "medium", username: "Khang")
}
