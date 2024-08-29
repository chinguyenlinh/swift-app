import SwiftUI

struct GameView: View {
    let difficulty: String
    
    @State private var hiddenColors: [Color] = []
    @State private var guessColors: [Color] = []
    @State private var showResult = false
    
    let availableColors: [Color] = [.red, .yellow, .blue, .green]
    let availableColorNames: [String]
    let gridColumns: [GridItem]
    
    init(difficulty: String) {
        self.difficulty = difficulty
        
        switch difficulty {
        case "easy":
            availableColorNames = ["blue", "green"]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible())] // 2 columns
        case "medium":
            availableColorNames = ["red", "yellow", "blue"]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 3 columns
        case "hard":
            availableColorNames = ["red", "yellow", "blue", "green"]
            gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 4 columns
        default:
            availableColorNames = ["blue", "green"]
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
                    ColorBlockView(color: .gray) // Hidden color block
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
                Alert(title: Text("Result"), message: Text(checkResult() ? "Correct!" : "Try Again"), dismissButton: .default(Text("OK")))
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
            blockCount = 2
        case "medium":
            blockCount = 3
        case "hard":
            blockCount = 4
        default:
            blockCount = 2
        }
        
        // Generate random hidden colors
        hiddenColors = availableColors.shuffled().prefix(blockCount).map { $0 }
        guessColors = Array(repeating: .clear, count: blockCount)
    }
    
    private func checkResult() -> Bool {
        // Compare guessed colors with hidden colors
        return guessColors.elementsEqual(hiddenColors)
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
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .green: return "Green"
        default: return "Unknown"
        }
    }
}

#Preview {
    GameView(difficulty: "easy")
}
