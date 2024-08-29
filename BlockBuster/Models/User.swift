import Foundation

struct User: Codable {
    var username: String
    var totalScore: Int
    var numGame: Int
    var winRate: Double
    var history: [GameHistory]
    var milestone: Milestone
    var achievement: Achievement
}
