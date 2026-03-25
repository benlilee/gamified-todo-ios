import SwiftUI

struct FinalRewardView: View {
    @StateObject private var api = APIService.shared
    @State private var customReward = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var completedTasks: Int {
        api.gameData?.tasks.filter { $0.completed }.count ?? 0
    }
    
    var totalTasks: Int {
        api.gameData?.tasks.count ?? 0
    }
    
    var isUnlocked: Bool {
        api.gameData?.finalReward.unlocked ?? false
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 终极奖励卡片
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    isUnlocked ? Color.pink.opacity(0.3) : Color.gray.opacity(0.2),
                                    isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(isUnlocked ? Color.yellow : Color.clear, lineWidth: 3)
                        )
                    
                    VStack(spacing: 20) {
                        Text("🎉")
                            .font(.system(size: 80))
                            .grayscale(isUnlocked ? 0 : 1)
                        
                        Text("终极奖励")
                            .font(.largeTitle.bold())
                            .foregroundColor(isUnlocked ? .yellow : .gray)
                        
                        Text("完成所有任务后，奖励自己一次!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // 进度
                        if !isUnlocked {
                            VStack(spacing: 10) {
                                Text("完成任务进度")
                                    .font(.headline)
                                
                                Text("\(completedTasks) / \(totalTasks)")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.purple)
                                
                                ProgressView(value: Double(completedTasks), total: Double(max(totalTasks, 1)))
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .tint(.purple)
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                            }
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(15)
                        } else {
                            // 已解锁，显示奖励
                            VStack(spacing: 15) {
                                Text("🎁 奖励内容")
                                    .font(.headline)
                                
                                TextField("输入你想奖励自己的东西...", text: $customReward)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(false)
                                    .padding(.horizontal)
                                
                                Text("💡 给自己一个难忘的奖励吧!")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(30)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .padding()
                
                // 提示
                if !isUnlocked && totalTasks > 0 {
                    VStack(spacing: 10) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        
                        Text("继续完成任务来解锁!")
                            .font(.headline)
                        
                        Text("完成所有 \(totalTasks) 个任务即可获得终极奖励")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        .onAppear {
            customReward = api.gameData?.finalReward.customReward ?? ""
        }
    }
}