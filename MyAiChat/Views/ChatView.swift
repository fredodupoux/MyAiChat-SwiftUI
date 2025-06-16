import SwiftUI

// A view that displays a chat interface for interacting with an AI assistant.
// This view handles:
// - Message display in a scrollable view
// - Text input and sending
// - Keyboard management with gesture-based dismissal
// - Auto-scrolling to new messages

// Background gradient
let homeBackground: [Color] = [
        .backgroundTop,
        .backgroundBottom
]

struct ChatView: View {
    // MARK: - Properties
    // Service for making API calls to OpenRouter
    // Manages API communication and maintains state across view updates
    @StateObject private var apiService = OpenRouterService()
    
    // Collection of messages in the current chat
    // Stores both user and AI messages in chronological order
    @State private var messages: [Message] = []
    
    // Text content of the input field
    // Current text in the input field
    @State private var inputText = ""
    
    // Controls keyboard focus state
    @FocusState private var isFocused: Bool
    
    // Flag indicating if a message is currently being processed
    // Used to show loading state and prevent multiple simultaneous requests
    @State private var isLoading = false
    
    // API key stored in app storage for persistence across app launches
    // Updated through settings and automatically persisted using @AppStorage
    @AppStorage("openrouter_api_key") private var apiKey: String = ""
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background color for the chat view
            LinearGradient(
                    gradient: Gradient(colors: homeBackground),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            
            // Main chat content
            
        VStack (alignment: .leading) {
            // Title for the chat view
            Text("My AI Chat")
                .font(.largeTitle .bold())
                .padding()
            // Messages area with ScrollViewReader for automatic scrolling to new messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                // Auto-scroll to the latest message when messages array changes
                .onChange(of: messages) { oldMessages, newMessages in
                    if let lastMessage = newMessages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                // Dismiss keyboard when tapping the messages area
                .onTapGesture {
                    isFocused = false
                }

            }
            
            // Input Area - text field with keyboard focus management and send button
            HStack {
                TextField("Type or ask anything...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isFocused)
                
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
    
        // Initialize API service with stored key when view appears
        .onAppear {
            apiService.setAPIKey(apiKey)
        }
        
        // Update API service when the API key changes in settings
        .onChange(of: apiKey) { oldKey, newKey in
            apiService.setAPIKey(newKey)
        }
     }
    } 
    // MARK: - Methods
    
    // Sends the user's message to the AI service and handles the response.
    // This method:
    // 1. Creates and adds the user's message
    // 2. Clears the input field
    // 3. Makes an async API call to get AI response
    // 4. Handles successful response by adding AI message
    // 5. Handles errors by displaying error message
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

// Preview provider for ChatView
// Displays the chat interface in Xcode's canvas
#Preview {
    ChatView()
}
