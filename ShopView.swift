import SwiftUI

struct ShopView: View {
    @StateObject private var api = APIService.shared
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(api.gameData?.rewards ?? []) { reward in
                    RewardCard(reward: reward, userCoins: api.gameData?.user.coins ?? 0) {
                        buyReward(reward)
                    }
                }
            }
            .padding()
        }
        .overlay {
            if showToast {
                VStack {
                    Spacer()
                    Text(toastMessage)
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    func buyReward(_ reward: Reward) {
        api.buyReward(id: reward.id) { success, message in
            toastMessage = success ? "🎉 \(reward.name) 已解锁!" : "❌ 金币不足"
            withAnimation {
                showToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                }
            }
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    let userCoins: Int
    let onBuy: () -> Void
    
    var canAfford: Bool {
        userCoins >= reward.cost && !reward.unlocked
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(reward.name)
                    .font(.headline)
                    .foregroundColor(reward.unlocked ? .green : .primary)
                
                Text(reward.unlocked ? "✅ 已解锁" : "💰 需要 \(reward.cost) 金币")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if reward.unlocked {
                Text("🎉")
                    .font(.title)
            } else {
                Button(action: onBuy) {
                    Text("购买")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(canAfford ? Color.purple : Color.gray)
                        .cornerRadius(20)
                }
                .disabled(!canAfford)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(reward.unlocked ? Color.green.opacity(0.1) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(reward.unlocked ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}