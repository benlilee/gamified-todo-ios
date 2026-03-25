import SwiftUI

struct AchievementsView: View {
    @StateObject private var api = APIService.shared
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(api.gameData?.achievements ?? []) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            .padding()
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 10) {
            Text(achievement.icon)
                .font(.system(size: 40))
                .grayscale(achievement.unlocked ? 0 : 1)
                .scaleEffect(achievement.unlocked ? 1.0 : 0.8)
            
            Text(achievement.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(achievement.desc)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if achievement.unlocked {
                Text("已解锁 ✓")
                    .font(.caption.bold())
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(achievement.unlocked ? Color.yellow.opacity(0.2) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(achievement.unlocked ? Color.yellow : Color.clear, lineWidth: 2)
        )
        .opacity(achievement.unlocked ? 1.0 : 0.6)
    }
}