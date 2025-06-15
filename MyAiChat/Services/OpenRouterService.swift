import Foundation

class OpenRouterService: ObservableObject {
    private let baseURL = "https://openrouter.ai/api/v1"
    private var apiKey: String = "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"
//    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
    
    func setAPIKey(_ key: String) {
        self.apiKey = key
    }
    
    func sendMessage(_ message: String) async throws -> String {
        guard !apiKey.isEmpty else {
            throw APIError.noAPIKey
        }
        
        let url = URL(string: "\(baseURL)/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "model": "google/gemini-2.0-flash-exp:free",
            "messages": [
                ["role": "user", "content": message]
            ]
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ChatResponse.self, from: data)
        
        return response.choices.first?.message.content ?? "No response"
    }
}

enum APIError: Error {
    case noAPIKey
    case invalidResponse
}

struct ChatResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: MessageContent
}

struct MessageContent: Codable {
    let content: String
}
