import SwiftUI

struct MilestoneView: View {
    @Environment(\.presentationMode) var presentationMode
    let user: User

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Milestones")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Group {
                    MilestoneDetail(title: "Scored over 10 points", achieved: user.milestone.over10Score)
                    MilestoneDetail(title: "Scored over 20 points", achieved: user.milestone.over20Score)
                    MilestoneDetail(title: "Scored over 50 points", achieved: user.milestone.over50Score)
                    MilestoneDetail(title: "Played a game on Easy", achieved: user.milestone.firstGamePlayedOnEasy)
                    MilestoneDetail(title: "Played a game on Medium", achieved: user.milestone.firstGamePlayedOnMedium)
                    MilestoneDetail(title: "Played a game on Hard", achieved: user.milestone.firstGamePlayedOnHard)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Milestones")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct MilestoneDetail: View {
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
    MilestoneView(user: User(username: "Khang", totalScore: 0, numGame: 0, winRate: 0, history: [], milestone: Milestone(over10Score: true, over20Score: false, over50Score: true, firstGamePlayedOnEasy: true, firstGamePlayedOnMedium: false, firstGamePlayedOnHard: true), achievement: Achievement(explorersFirstStep: false, strategicThinker: false, persistentPlayer: false, curiousMind: false, precisionTraining: false, quickLearner: false)))
}
