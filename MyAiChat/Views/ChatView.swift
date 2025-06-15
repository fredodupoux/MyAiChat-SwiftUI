import SwiftUI

/// A view that displays a chat interface for interacting with an AI assistant
struct ChatView: View {
    // MARK: - Properties
    // Service for making API calls to OpenRouter
    @StateObject private var apiService = OpenRouterService()
    
    // Collection of messages in the current chat
    @State private var messages: [Message] = []
    
    // Text content of the input field
    @State private var inputText = ""
    
    // Flag indicating if a message is currently being processed
    @State private var isLoading = false
    
    // API key stored in app storage for persistence across app launches
    @AppStorage("openrouter_api_key") private var apiKey: String = ""
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Messages List - scrollable area showing conversation history
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Input Area - text field and send button
            HStack {
                TextField("Type or ask anything...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    if (inputText.isEmpty || isLoading) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.gray)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                        }
                    }
                // Disable send button when input is empty or still waiting for response
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle("Chat")
        // Set the API key when the view appears
        .onAppear {
            apiService.setAPIKey(apiKey)
        }
        // Update the API service when the API key changes
        .onChange(of: apiKey) { oldKey, newKey in
            apiService.setAPIKey(newKey)
        }
    }
    
    // MARK: - Methods
    
    /// Sends the user's message to the AI service and handles the response
    private func sendMessage() {
        // Return early if there's no message to send
        guard !inputText.isEmpty else { return }
        
        // Create and add user message to the conversation
        let userMessage = Message(content: inputText, isFromUser: true)
        messages.append(userMessage)
        
        // Store message text and reset input field
        let messageText = inputText
        inputText = ""
        isLoading = true
        
        // Make asynchronous API call
        Task {
            do {
                // Send message to AI service and wait for response
                let response = try await apiService.sendMessage(messageText)
                let aiMessage = Message(content: response, isFromUser: false)
                
                // Update UI on the main thread
                await MainActor.run {
                    messages.append(aiMessage)
                    isLoading = false
                }
            } catch {
                // Handle errors by displaying them in the chat
                await MainActor.run {
                    let errorMessage = Message(content: "Error: \(error.localizedDescription)", isFromUser: false)
                    messages.append(errorMessage)
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
