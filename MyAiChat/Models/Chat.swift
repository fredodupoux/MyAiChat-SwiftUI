import Foundation

struct Chat: Identifiable, Codable {
    let id = UUID()
    let title: String
    var messages: [Message]
    let createdAt: Date
    
    init(title: String) {
        self.title = title
        self.messages = []
        self.createdAt = Date()
    }
}