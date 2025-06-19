import Foundation

class OpenRouterService: ObservableObject {
    private let baseURL = "https://openrouter.ai/api/v1"
    private var apiKey: String = ""
    
    func setAPIKey(_ key: String) {
        self.apiKey = key
    }
    
    func sendMessage(_ message: String, conversationHistory: [(content: String, isFromUser: Bool)] = []) async throws -> String {
        guard !apiKey.isEmpty else {
            throw APIError.noAPIKey
        }
        
        let url = URL(string: "\(baseURL)/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build messages array with conversation history
        var messages: [[String: String]] = [
            ["role": "system", "content": "You are a helpful and encouraging AI tutor for young students. Always use simple, clear language that's easy to understand. Keep your explanations safe, positive, and age-appropriate. Never use markdown, formatting, tables in your responses. Always reply in correct gramar and plain text using simple paragraphs with proper punctuation occasionally use emojis. Break down complex topics into easy steps and encourage learning."]
        ]
        
        // Add conversation history
        for msg in conversationHistory {
            let role = msg.isFromUser ? "user" : "assistant"
            messages.append(["role": role, "content": msg.content])
        }
        
        // Add current message
        messages.append(["role": "user", "content": message])
        
        let requestBody = [
            "model": "google/gemini-2.0-flash-exp:free",
            "messages": messages
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
