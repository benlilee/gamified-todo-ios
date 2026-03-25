import Foundation

struct User: Codable {
    var name: String
    var level: Int
    var exp: Int
    var expToNext: Int
    var coins: Int
    var totalTasksCompleted: Int
    var streak: Int
    var lastActive: String
}

struct TaskItem: Codable, Identifiable {
    var id: Int
    var title: String
    var desc: String
    var difficulty: String
    var assignedTo: String?
    var deadline: String?
    var completed: Bool
    var completedAt: String?
    var createdAt: String
}

struct Reward: Codable, Identifiable {
    var id: Int
    var name: String
    var cost: Int
    var unlocked: Bool
}

struct Achievement: Codable, Identifiable {
    var id: String
    var name: String
    var desc: String
    var icon: String
    var unlocked: Bool
}

struct FinalReward: Codable {
    var name: String
    var desc: String
    var customReward: String
    var unlocked: Bool
}

struct GameData: Codable {
    var user: User
    var tasks: [TaskItem]
    var rewards: [Reward]
    var achievements: [Achievement]
    var finalReward: FinalReward
}