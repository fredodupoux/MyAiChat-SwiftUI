import SwiftUI

/*
 ChatGPT Interface Breakdown
 
 The image shows a mobile interface that resembles a chat application with the following components:
 
 1. Status Bar (top)
 2. Navigation Bar with menu button, title, and compose button
 3. Chat message bubble with a list of requirements
 4. Bottom section with input field and controls
 
 Let's break down each component and how it can be implemented in SwiftUI
 */

struct ChatGPTInterfaceDemo: View {
    @State private var messageText = ""
    
    var body: some View {
        // Main container with navigation
        NavigationView {
            VStack(spacing: 0) {
                // Main content area (chat messages)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Gray bubble with requirements text
                        MessageBubbleView()
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // "Updated saved memory" row
                        HStack(spacing: 10) {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.gray)
                            Text("Updated saved memory")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Response text
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Great! Here's a").font(.body) +
                            Text(" detailed 5-day plan").font(.body).bold() +
                            Text(" for your iOS coding bootcamp, designed for 14-year-olds to gradually learn Swift and SwiftUI while building a simple LLM chat app. Each day is split into").font(.body)
                            
                            HStack(spacing: 0) {
                                Text("Morning (Concepts + Demos)").font(.body).bold()
                                Text(" and").font(.body)
                            }
                            
                            HStack(spacing: 0) {
                                Text("Afternoon (Hands-On Practice)").font(.body).bold()
                                Text(" sessions.").font(.body)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                
                // Down arrow indicator (for scrolling)
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                        .shadow(radius: 2)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding(.top, -18)
                .zIndex(1)
                
                // Bottom input area
                VStack {
                    Divider()
                    
                    HStack(alignment: .bottom) {
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "waveform")
                                        .foregroundColor(.white)
                                )
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 10)
                    
                    // "Ask anything" placeholder text (shown at bottom)
                    HStack {
                        Text("Ask anything")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
                .background(Color(UIColor.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.black)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("ChatGPT")
                            .font(.headline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

// The gray message bubble with requirements
struct MessageBubbleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            bulletPoint("Simulate a login screen with the hard coded credentials")
            bulletPoint("Open the main screen of the app with 2 tabs. (Chat and Settings")
            bulletPoint("Chat with an LLM from openRouter.io (hard coded model)")
            bulletPoint("Set the openRouter.io token in the settings page")
            bulletPoint("Chose a model in a scrollable list based on a hard coded list of models")
            
            Text("We will skip the API and the networking integration as it might be too advanced but will include files for it to work")
                .padding(.top, 8)
        }
        .padding(16)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top) {
            Text("- ")
            Text(text)
        }
    }
}

// The status bar replica (time, signal strength, battery)
struct StatusBarView: View {
    var body: some View {
        HStack {
            Text("22:37")
                .bold()
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Image(systemName: "wifi")
                Text("45")
                    .padding(2)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 12))
                Image(systemName: "battery.75")
            }
        }
        .padding(.horizontal)
        .font(.system(size: 14))
    }
}

// Preview
struct ChatGPTInterfaceDemo_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTInterfaceDemo()
    }
}

/*
 Key Components Breakdown:
 
 1. Navigation Bar:
    - Uses NavigationView with toolbar items
    - Left: Menu button (hamburger icon)
    - Center: Title "ChatGPT" with a chevron
    - Right: Compose button
 
 2. Message Bubble:
    - Gray background with rounded corners
    - Contains bullet points with requirements
    - Implemented as a separate view for reusability
 
 3. Response Text:
    - Combines regular and bold text
    - Shows the beginning of a response about a 5-day plan
 
 4. Down Arrow Indicator:
    - Circle with drop shadow
    - Chevron icon inside
    - Positioned slightly overlapping content
 
 5. Bottom Input Area:
    - Contains action buttons (plus, settings)
    - Contains voice input buttons (microphone, waveform)
    - Shows placeholder text "Ask anything"
 
 UI Techniques Used:
 - ZStack for overlapping elements (down arrow)
 - HStack and VStack for layout
 - Combining Text views with different formatting
 - Custom styling for buttons and indicators
 - System icons from SF Symbols
 
 To rebuild this interface:
 1. Start with the basic NavigationView structure
 2. Add the ScrollView for message content
 3. Create the message bubble component
 4. Style the text response with mixed formatting
 5. Add the bottom input area with buttons
 6. Fine-tune spacing and colors to match the design
 */
