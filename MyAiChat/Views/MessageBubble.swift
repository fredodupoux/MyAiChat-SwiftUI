import SwiftUI

/// A view component that displays a single chat message as a bubble
/// with different styling based on whether it's from the user or AI
struct MessageBubble: View {
    /// The message data to be displayed in the bubble
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                // User messages are aligned to the right with blue background
                Spacer()
                messageContent
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 1)
                    .foregroundColor(.white)
            } else {
                // AI messages are aligned to the left with light gray background
                messageContent
                // set to primary color for better contrast
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
    /// The content view for the message bubble
    /// Contains the message text and timestamp
    private var messageContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Message content text
            Text(message.content)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            // Timestamp displayed below the message
            Text(message.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
            .padding(.bottom, 6)}

    }
}
/// Preview provider for the MessageBubble view

#Preview {
    Group {
        // Example of a user message
        MessageBubble(message: Message(content: "Hello, how are you?", isFromUser: true))
        // Example of an AI assistant message
        MessageBubble(message: Message(content: "I'm doing great, thanks for asking!", isFromUser: false))
    }
}
