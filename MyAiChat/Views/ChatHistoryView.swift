import SwiftUI

struct ChatHistoryView: View {
    @State private var chats: [Chat] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chats) { chat in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(chat.title)
                            .font(.headline)
                        
                        Text("\(chat.messages.count) messages")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(chat.createdAt, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
                .onDelete(perform: deleteChats)
            }
            .navigationTitle("Chat History")
            .toolbar {
                EditButton()
            }
            .onAppear {
                loadChats()
            }
        }
    }
    
    private func loadChats() {
        // Load chats from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "saved_chats"),
           let savedChats = try? JSONDecoder().decode([Chat].self, from: data) {
            chats = savedChats
        }
    }
    
    private func deleteChats(offsets: IndexSet) {
        chats.remove(atOffsets: offsets)
        saveChats()
    }
    
    private func saveChats() {
        if let data = try? JSONEncoder().encode(chats) {
            UserDefaults.standard.set(data, forKey: "saved_chats")
        }
    }
}

#Preview {
    ChatHistoryView()
}
