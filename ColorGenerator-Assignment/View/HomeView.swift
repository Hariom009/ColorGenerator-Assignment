import SwiftUI
import SwiftData


struct HomeView: View {
    @Query(sort: \ColorCode.createdAt, order: .reverse) var colours: [ColorCode]
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Button{
                    viewModel.generateRandomColor(context: context)
                    if networkMonitor.isConnected{
                        Task {
                            await FirebaseManager.shared.syncUnsyncedColors(context: context)
                        }
                    }
                }label:{
                    Text("Generate Color")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(colours) { colorCode in
                            VStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: colorCode.hex) ?? .gray)
                                    .frame(height: 100)
                                    .overlay(
                                        Text(colorCode.hex)
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(6),
                                        alignment: .bottomTrailing
                                    )
                                    .shadow(radius: 4)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Color Generator")
            .toolbar{
                Button{
                    networkMonitor.refreshConnectionStatus()
                }label:{
                    Circle()
                        .fill(networkMonitor.isConnected ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text("\(networkMonitor.isConnected ? "Online" : "Offline")")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }
            }
        }
        .onChange(of: networkMonitor.isConnected) { connected in
            if connected {
                Task {
                    await FirebaseManager.shared.syncUnsyncedColors(context: context)
                }
            }
        }
    }
}
