import SwiftUI

struct DashboardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var userManager = UserManager()
    let username: String
    
    @State private var user: User?
    @State private var showingAchievements = false
    @State private var showingMilestones = false
    @State private var showingHistory = false

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
                        Button(action: {
                            showingMilestones = true
                        }) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Milestones: \(completedMilestones())/6")
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showingMilestones) {
                            MilestoneView(user: user)
                        }

                        // Achievements
                        Button(action: {
                            showingAchievements = true
                        }) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Achievements: \(completedAchievements())")
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showingAchievements) {
                            AchievementView(user: user)
                        }

                        // History
                        Button(action: {
                            showingHistory = true
                        }) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("History")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showingHistory) {
                            HistoryView(user: user)
                        }
                    }
                } else {
                    Text("User not found")
                        .font(.headline)
                        .foregroundColor(.red)
                }

                Spacer()
                
                Button(action: {
                    handleLogout()
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
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
    
    private func completedMilestones() -> Int {
        let milestones = [
            user?.milestone.over10Score ?? false,
            user?.milestone.over20Score ?? false,
            user?.milestone.over50Score ?? false,
            user?.milestone.firstGamePlayedOnEasy ?? false,
            user?.milestone.firstGamePlayedOnMedium ?? false,
            user?.milestone.firstGamePlayedOnHard ?? false
        ]
        return milestones.filter { $0 }.count
    }

    private func completedAchievements() -> Int {
        let achievements = [
            user?.achievement.explorersFirstStep ?? false,
            user?.achievement.strategicThinker ?? false,
            user?.achievement.persistentPlayer ?? false,
            user?.achievement.curiousMind ?? false,
            user?.achievement.precisionTraining ?? false,
            user?.achievement.quickLearner ?? false
        ]
        return achievements.filter { $0 }.count
    }

    private func handleLogout() {
        dismiss()
    }
}

#Preview {
    DashboardView(username: "Khang")
}
