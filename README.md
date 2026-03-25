# 🎮 冒险待办清单 - iOS App

用 SwiftUI 开发的原生 iOS App

## 📱 在 Xcode 中运行

### 1. 创建新项目
1. 打开 Xcode
2. 选择 **Create a new Xcode project**
3. 选择 **App** under **iOS**
4. 填入项目名: `GamifiedTodo`
5. Interface 选择 **SwiftUI**
6. 点击 **Next**

### 2. 添加文件
1. 在左侧项目导航器，右键点击项目名称
2. 选择 **New Group** 创建 `Views` 和 `Services` 文件夹
3. 右键 `Views`，选择 **New File**
4. 选择 **Swift File**，创建以下文件：
   - `ContentView.swift`
   - `TaskListView.swift`
   - `ShopView.swift`
   - `AchievementsView.swift`
   - `FinalRewardView.swift`
5. 右键 `Services`，创建：
   - `Models.swift`
   - `APIService.swift`
6. 删除自动生成的 `ContentView.swift`（如果有）

### 3. 复制代码
复制对应文件的内容到 Xcode 中。

### 4. 配置网络权限
1. 点击项目名称
2. 选择 **Info** 标签
3. 找到 **App Transport Security Settings**
4. 展开 **Exception Domains**
5. 添加 `localhost`，设为 `NO`

或者在 `Info.plist` 中添加：
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 5. 运行
1. 选择模拟器或真机
2. 点击 ▶️ 运行

## ⚠️ 注意事项

- 需要先运行后端服务器（参考 `gamified-todo` 文件夹）
- 默认连接 `http://localhost:3001`
- 真机测试需要把 localhost 改成电脑的 IP 地址

## 📋 功能

- ✅ 添加任务（可指派、设置难度和截止日期）
- ⭐ 升级系统（完成任务获得经验）
- 💰 金币商店（购买奖励）
- 🏆 成就系统
- 🎁 终极奖励（完成所有任务后解锁）
- 🔥 连续打卡天数追踪

## 🔧 修改后端地址

在 `APIService.swift` 中修改 `baseURL`:
```swift
let baseURL = "http://你的电脑IP:3001"
```

真机测试时，把 `localhost` 改成电脑的局域网 IP 地址。
