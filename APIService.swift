import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    
    let baseURL = "http://localhost:3001"
    
    @Published var gameData: GameData?
    @Published var isLoading = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        guard let url = URL(string: "\(baseURL)/api/data") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    self.gameData = try? decoder.decode(GameData.self, from: data)
                }
                self.isLoading = false
            }
        }.resume()
    }
    
    func addTask(title: String, desc: String, difficulty: String, assignedTo: String?, deadline: String?) {
        guard let url = URL(string: "\(baseURL)/api/tasks") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "title": title,
            "desc": desc,
            "difficulty": difficulty,
            "assignedTo": assignedTo as Any,
            "deadline": deadline as Any
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.loadData()
            }
        }.resume()
    }
    
    func completeTask(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/tasks/\(id)/complete") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    let _ = try? JSONSerialization.jsonObject(with: data)
                }
                self.loadData()
                completion(true)
            }
        }.resume()
    }
    
    func deleteTask(id: Int) {
        guard let url = URL(string: "\(baseURL)/api/tasks/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.loadData()
            }
        }.resume()
    }
    
    func buyReward(id: Int, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/rewards/\(id)/buy") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.loadData()
                    completion(true, "购买成功!")
                } else {
                    completion(false, "金币不足")
                }
            }
        }.resume()
    }
}