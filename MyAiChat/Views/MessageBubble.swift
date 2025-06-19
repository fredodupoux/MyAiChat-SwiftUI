import SwiftUI

/// A view component that displays a single chat message as a bubble
/// with different styling based on whether it's from the user or AI
struct MessageBubble: View {
    /// The message data to be displayed in the bubble
    let message: Message
    
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
    
    var body: some View {
        HStack {
            if message.isFromUser {
                // User messages are aligned to the right with blue background
                Spacer()
                messageContent
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 1)
                    .foregroundColor(.white)
                    .padding(.leading, 40)
            } else {
                VStack {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .padding(.leading, 6)
                        Spacer()
                    }
                    messageContent
                    // set to primary color for better contrast
                        .foregroundColor(.primary)
                }
//                Spacer()
            }
        }
    }
    

}
/// Preview provider for the MessageBubble view

#Preview {
        // Example of a user message
        MessageBubble(message: Message(content: "Hello, how are you? What if i have a very long question? will it wrap automatically too ?", isFromUser: true))
        // Example of an AI assistant message
        MessageBubble(message: Message(content: "I'm doing great, thanks for asking! This is an exemple of a long text that will wrap automatically", isFromUser: false))
}
