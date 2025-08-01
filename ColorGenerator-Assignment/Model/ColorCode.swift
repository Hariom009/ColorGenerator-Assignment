import Foundation
import SwiftUI
import SwiftData

@Model
class ColorCode {
    var id: UUID
    var hex: String
    var isSynced: Bool
    var createdAt: Date
    
    init(hex: String, isSynced: Bool = false, createdAt: Date = Date()) {
        self.id = UUID()
        self.hex = hex
        self.isSynced = isSynced
        self.createdAt = createdAt
    }
}


extension Color {
    init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }

        guard hexFormatted.count == 6,
              let rgb = UInt64(hexFormatted, radix: 16) else {
            return nil
        }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
