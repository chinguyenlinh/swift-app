import Foundation

struct GameHistory: Codable, Identifiable {
    var id: Int
    var difficulty: String
    var blocks: [String]
    var target: [String]
    var result: String
    var winRate: Double
    var score: Int
}
