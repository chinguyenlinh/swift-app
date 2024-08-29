import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    let user: User

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Game History")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                if user.history.isEmpty {
                    Text("No History. Please play the game.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(user.history) { game in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Game ID: \(game.id)")
                            Text("Difficulty: \(game.difficulty.capitalized)")
                            Text("Score: \(game.score)")
                            Text("Result: \(game.result)")
                        }
                        .padding(.bottom, 5)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("History")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    HistoryView(user: User(username: "Khang", totalScore: 0, numGame: 0, winRate: 0, history: [], milestone: Milestone(over10Score: false, over20Score: false, over50Score: false, firstGamePlayedOnEasy: false, firstGamePlayedOnMedium: false, firstGamePlayedOnHard: false), achievement: Achievement(explorersFirstStep: false, strategicThinker: false, persistentPlayer: false, curiousMind: false, precisionTraining: false, quickLearner: false)))
}
