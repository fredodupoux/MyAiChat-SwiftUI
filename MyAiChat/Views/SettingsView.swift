import SwiftUI

struct SettingsView: View {
    @AppStorage("openrouter_api_key") private var apiKey: String = ""
    @State private var tempApiKey: String = ""
    @State private var showingSaveAlert = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("API Configuration")) {
                    SecureField("OpenRouter API Key", text: $tempApiKey)
                        .onAppear {
                            tempApiKey = apiKey
                        }
                    
                    Button("Save API Key") {
                        apiKey = tempApiKey
                        showingSaveAlert = true
                    }
                    .disabled(tempApiKey.isEmpty)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("OpenRouter Website", 
                         destination: URL(string: "https://openrouter.ai")!)
                }
            }
            .navigationTitle("Settings")
            .alert("API Key Saved", isPresented: $showingSaveAlert) {
                Button("OK") { }
            }
        }
    }
}

#Preview {
    SettingsView()
}
