import SwiftUI

struct GameView: View {
    let difficulty: String
    
    @State private var hiddenColors: [Color] = []
    @State private var guessColors: [Color] = []
    @State private var showResult = false
    @State private var revealHiddenColors = false
    
    let availableColors: [Color]
    let gridColumns: [GridItem]
    
    init(difficulty: String) {
        self.difficulty = difficulty
        
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
                showResult = true
                revealHiddenColors = true // Reveal hidden colors when checking
            }) {
                Text("Check")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert(isPresented: $showResult) {
                Alert(title: Text("Result"), message: Text(checkResult() ? "Correct!" : "Incorrect"), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Game")
        .onAppear {
            setupGame()
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
    
    private func checkResult() -> Bool {
        // Compare guessed colors with hidden colors
        return guessColors == hiddenColors
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
    GameView(difficulty: "medium")
}
