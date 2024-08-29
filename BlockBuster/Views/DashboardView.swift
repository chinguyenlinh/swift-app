import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            // Add more content related to your app's dashboard here
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

#Preview {
    DashboardView()
}
