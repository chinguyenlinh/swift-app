import SwiftUI

struct GameView: View {
    let difficulty: String
    
    var body: some View {
        VStack {
            Text("Game View")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Difficulty: \(difficulty.capitalized)")
                .font(.title)
                .padding(.bottom, 20)
            
            // Add game logic and UI here
            Text("Game content goes here...")
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Game")
    }
}

#Preview {
    GameView(difficulty: "medium")
}
