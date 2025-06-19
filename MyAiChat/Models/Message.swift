import Foundation

/// This view represents a single chat message.
struct Message: Identifiable, Codable, Equatable {
    /// Unique identifier for the message.
    let id = UUID()
    /// The text content of the message.
    let content: String
    /// Indicates if the message was sent by the user.
    let isFromUser: Bool
    /// The date and time when the message was created.
    let timestamp: Date
    
    /// Initializes a new Message with the given content and sender flag.
    /// - Parameters:
    ///   - content: The text of the message.
    ///   - isFromUser: True if the message is from the user, false otherwise.
    init(content: String, isFromUser: Bool) {
        
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
    }
}
