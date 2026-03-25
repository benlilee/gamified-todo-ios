import SwiftUI

struct ContentView: View {
    @StateObject private var api = APIService.shared
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 用户状态头部
                if let user = api.gameData?.user {
                    UserStatsHeader(user: user)
                }
                
                // Tab选择
                Picker("", selection: $selectedTab) {
                    Text("📋 任务").tag(0)
                    Text("🛒 商店").tag(1)
                    Text("🏆 成就").tag(2)
                    Text("🎁 奖励").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 内容
                TabView(selection: $selectedTab) {
                    TaskListView()
                        .tag(0)
                    ShopView()
                        .tag(1)
                    AchievementsView()
                        .tag(2)
                    FinalRewardView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("🎮 冒险待办")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserStatsHeader: View {
    let user: User
    
    var expProgress: Double {
        guard user.expToNext > 0 else { return 0 }
        return Double(user.exp) / Double(user.expToNext)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 20) {
                StatItem(icon: "⭐", value: "\(user.level)", label: "等级")
                StatItem(icon: "💰", value: "\(user.coins)", label: "金币")
                StatItem(icon: "🔥", value: "\(user.streak)", label: "天数")
                StatItem(icon: "✅", value: "\(user.totalTasksCompleted)", label: "已完成")
            }
            
            // 经验条
            VStack(spacing: 5) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: geometry.size.width * expProgress, height: 10)
                    }
                }
                .frame(height: 10)
                
                Text("经验: \(user.exp) / \(user.expToNext)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.95))
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}