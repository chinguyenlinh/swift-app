import SwiftUI

struct WelcomeView: View {
    @State private var username: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to BlockBuster!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                TextField("Enter your username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Handle login/register action
                    if !username.isEmpty {
                        isLoggedIn = true
                    }
                }) {
                    Text("Login / Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink("Continue to Dashboard", value: isLoggedIn)
                    .opacity(0)
                    .disabled(true)
            }
            .padding()
            .navigationTitle("Welcome")
            .navigationDestination(isPresented: $isLoggedIn) {
                DashboardView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
