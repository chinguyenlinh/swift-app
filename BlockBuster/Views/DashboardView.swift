import SwiftUI

struct DashboardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var userManager = UserManager()
    let username: String
    
    @State private var user: User?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                if let user = user {
                    VStack(alignment: .leading, spacing: 15) {
                        // User Statistics
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(user.username)")
                            Text("Total Score: \(user.totalScore)")
                            Text("Number of Games: \(user.numGame)")
                            Text("Win Rate: \(user.winRate, specifier: "%.2f")")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                        // Milestones
                        let completedMilestones = [
                            user.milestone.over10Score,
                            user.milestone.over20Score,
                            user.milestone.over50Score,
                            user.milestone.firstGamePlayedOnEasy,
                            user.milestone.firstGamePlayedOnMedium,
                            user.milestone.firstGamePlayedOnHard
                        ].filter { $0 }.count

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Milestones: \(completedMilestones)/6")
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(10)

                        // Achievements
                        let completedAchievements = [
                            user.achievement.explorersFirstStep,
                            user.achievement.strategicThinker,
                            user.achievement.persistentPlayer,
                            user.achievement.curiousMind,
                            user.achievement.precisionTraining,
                            user.achievement.quickLearner
                        ].filter { $0 }.count

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Achievements: \(completedAchievements)")
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)

                        // History
                        VStack(alignment: .leading, spacing: 10) {
                            Text("History:")
                                .font(.headline)

                            ForEach(user.history) { game in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Game ID: \(game.id)")
                                    Text("Difficulty: \(game.difficulty.capitalized)")
                                    Text("Score: \(game.score)")
                                    Text("Result: \(game.result)")
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                } else {
                    Text("User not found")
                        .font(.headline)
                        .foregroundColor(.red)
                }

                Spacer()
                
                NavigationLink("Logout", destination: ContentView())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .onAppear {
                loadUser()
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }

    private func loadUser() {
        user = userManager.getUser(username: username)
    }
}

#Preview {
    DashboardView(username: "Khang")
}
