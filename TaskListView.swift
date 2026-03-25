import SwiftUI

struct TaskListView: View {
    @StateObject private var api = APIService.shared
    @State private var showingAddTask = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack {
            if api.isLoading {
                ProgressView("加载中...")
            } else if let tasks = api.gameData?.tasks, tasks.isEmpty {
                VStack(spacing: 20) {
                    Text("📝")
                        .font(.system(size: 60))
                    Text("还没有任务")
                        .font(.headline)
                    Text("添加一个开始冒险吧!")
                        .foregroundColor(.secondary)
                    Button("➕ 添加任务") {
                        showingAddTask = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                List {
                    ForEach(api.gameData?.tasks ?? []) { task in
                        TaskRow(task: task, onComplete: {
                            completeTask(task)
                        }, onDelete: {
                            deleteTask(task)
                        })
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    api.loadData()
                }
            }
            
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
        .sheet(isPresented: $showingAddTask) {
            AddTaskView { title, desc, difficulty, assignedTo, deadline in
                api.addTask(title: title, desc: desc, difficulty: difficulty, assignedTo: assignedTo, deadline: deadline)
                showingAddTask = false
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: { showingAddTask = true }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
        }
    }
    
    func completeTask(_ task: TaskItem) {
        api.completeTask(id: task.id) { success in
            if success {
                let reward = rewardForDifficulty(task.difficulty)
                toastMessage = "💰 +\(reward.coins)金币 ⭐ +\(reward.exp)经验"
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
    
    func deleteTask(_ task: TaskItem) {
        api.deleteTask(id: task.id)
    }
    
    func rewardForDifficulty(_ difficulty: String) -> (coins: Int, exp: Int) {
        switch difficulty {
        case "easy": return (10, 10)
        case "hard": return (50, 40)
        default: return (20, 20)
        }
    }
}

struct TaskRow: View {
    let task: TaskItem
    let onComplete: () -> Void
    let onDelete: () -> Void
    
    var difficultyColor: Color {
        switch task.difficulty {
        case "easy": return .green
        case "hard": return .red
        default: return .yellow
        }
    }
    
    var difficultyIcon: String {
        switch task.difficulty {
        case "easy": return "🟢"
        case "hard": return "🔴"
        default: return "🟡"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(difficultyIcon)
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.completed)
                    .foregroundColor(task.completed ? .gray : .primary)
                Spacer()
                if task.completed {
                    Text("✅")
                }
            }
            
            if !task.desc.isEmpty {
                Text(task.desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if let assignedTo = task.assignedTo, !assignedTo.isEmpty {
                    Label(assignedTo, systemImage: "person.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                if let deadline = task.deadline, !deadline.isEmpty {
                    Label(deadline, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 5)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Label("删除", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            if !task.completed {
                Button(action: onComplete) {
                    Label("完成", systemImage: "checkmark")
                }
                .tint(.green)
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var desc = ""
    @State private var difficulty = "medium"
    @State private var assignedTo = ""
    @State private var deadline = Date()
    @State private var hasDeadline = false
    
    let onAdd: (String, String, String, String?, String?) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("任务信息") {
                    TextField("任务名称", text: $title)
                    TextField("任务描述(可选)", text: $desc)
                }
                
                Section("难度") {
                    Picker("难度", selection: $difficulty) {
                        Text("🟢 简单 (+10金币)").tag("easy")
                        Text("🟡 中等 (+20金币)").tag("medium")
                        Text("🔴 困难 (+50金币)").tag("hard")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("指派") {
                    TextField("指派给谁(可选)", text: $assignedTo)
                }
                
                Section("截止日期") {
                    Toggle("设置截止日期", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("截止日期", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("添加任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        let deadlineStr = hasDeadline ? ISO8601DateFormatter().string(from: deadline) : nil
                        onAdd(title, desc, difficulty, assignedTo.isEmpty ? nil : assignedTo, deadlineStr)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}