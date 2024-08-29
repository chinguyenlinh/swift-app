import SwiftUI

struct AchievementView: View {
    @Environment(\.presentationMode) var presentationMode
    let user: User

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Achievements")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Group {
                    AchievementDetail(title: "Explorer's First Step", achieved: user.achievement.explorersFirstStep)
                    AchievementDetail(title: "Strategic Thinker", achieved: user.achievement.strategicThinker)
                    AchievementDetail(title: "Persistent Player", achieved: user.achievement.persistentPlayer)
                    AchievementDetail(title: "Curious Mind", achieved: user.achievement.curiousMind)
                    AchievementDetail(title: "Precision Training", achieved: user.achievement.precisionTraining)
                    AchievementDetail(title: "Quick Learner", achieved: user.achievement.quickLearner)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Achievements")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AchievementDetail: View {
    let title: String
    let achieved: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(achieved ? "✔️" : "❌")
                .foregroundColor(achieved ? .green : .red)
        }
    }
}

#Preview {
    AchievementView(user: User(username: "Khang", totalScore: 0, numGame: 0, winRate: 0, history: [], milestone: Milestone(over10Score: false, over20Score: false, over50Score: false, firstGamePlayedOnEasy: false, firstGamePlayedOnMedium: false, firstGamePlayedOnHard: false), achievement: Achievement(explorersFirstStep: true, strategicThinker: false, persistentPlayer: true, curiousMind: false, precisionTraining: false, quickLearner: true)))
}
