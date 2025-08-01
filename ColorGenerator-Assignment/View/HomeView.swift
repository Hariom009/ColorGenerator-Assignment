import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \ColorCode.createdAt, order: .reverse) var colours: [ColorCode]
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    // Animation and UI state
    @State private var isGenerating = false
    @State private var showingColorDetail = false
    @State private var selectedColor: ColorCode?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header section with gradient background
                headerSection
                
                // Main content
                mainContent
                
                GenerateButton
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Color Generator")
            //.navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    networkStatusButton
                }
            }
        }
        .sheet(item: $selectedColor) { color in
            ColorDetailView(colorCode: color)
        }
        .onChange(of: networkMonitor.isConnected) { connected in
            if connected {
                Task {
                    await FirebaseManager.shared.syncUnsyncedColors(context: context)
                }
            }
        }
    }
    
    private var GenerateButton: some View {
        // Generate button with improved styling
        VStack{
            Button {
                generateColorWithAnimation()
            } label: {
                HStack {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paintpalette.fill")
                            .font(.title3)
                    }
                    
                    Text(isGenerating ? "Generating..." : "Generate New Color")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: isGenerating ? [.gray, .gray.opacity(0.8)] : [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                
            }
            .disabled(isGenerating)
            .scaleEffect(isGenerating ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isGenerating)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Stats section
            if !colours.isEmpty {
                HStack(spacing: 20) {
                    StatView(title: "Total Colors", value: "\(colours.count)")
                    StatView(title: "Recent", value: recentColorsCount)
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        Group {
            if colours.isEmpty {
                emptyStateView
            } else {
                colorGridView
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintpalette")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Colors Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Tap the button above to generate your first color")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Color Grid
    private var colorGridView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(colours) { colorCode in
                    ColorCardView(
                        colorCode: colorCode,
                        onTap: { selectedColor = colorCode }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100) // Extra padding for better scrolling
        }
    }
    
    // MARK: - Network Status Button
    private var networkStatusButton: some View {
        Button {
            networkMonitor.refreshConnectionStatus()
        } label: {
            HStack(spacing: 6) {
                Circle()
                    .fill(networkMonitor.isConnected ? .green : .red)
                    .frame(width: 8, height: 8)
                
                Text(networkMonitor.isConnected ? "Online" : "Offline")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Helper Properties
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    }
    
    private var recentColorsCount: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let recentCount = colours.filter { color in
            calendar.isDate(color.createdAt, inSameDayAs: today)
        }.count
        return "\(recentCount)"
    }
    
    // MARK: - Helper Methods
    private func generateColorWithAnimation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isGenerating = true
        }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        viewModel.generateRandomColor(context: context)
        
        if networkMonitor.isConnected {
            Task {
                await FirebaseManager.shared.syncUnsyncedColors(context: context)
            }
        }
        
        // Reset generating state after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isGenerating = false
            }
        }
    }
}

// MARK: - Supporting Views

struct ColorCardView: View {
    let colorCode: ColorCode
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Color preview
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: colorCode.hex) ?? .gray)
                    .aspectRatio(1.2, contentMode: .fit)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(colorCode.hex.uppercased())
                                    .font(.system(.caption, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.black.opacity(0.6))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(12)
                    )
                
                // Color info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Created")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatDate(colorCode.createdAt))
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { 
            // Handle press state for animation
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ColorDetailView: View {
    let colorCode: ColorCode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Large color preview
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: colorCode.hex) ?? .gray)
                    .frame(height: 300)
                    .shadow(radius: 12)
                
                // Color information
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Hex Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(colorCode.hex.uppercased())
                            .font(.system(.title, design: .monospaced))
                            .fontWeight(.bold)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Created")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(colorCode.createdAt, style: .date)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                // Copy button
                Button {
                    UIPasteboard.general.string = colorCode.hex
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Hex Code")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Color Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
