import Foundation
import SwiftData
import Firebase
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {}

    func syncUnsyncedColors(context: ModelContext) async {
        let descriptor = FetchDescriptor<ColorCode>(
            predicate: #Predicate { !$0.isSynced }
        )

        do {
            let unsyncedColors = try context.fetch(descriptor)

            for colorCode in unsyncedColors {
                try await uploadColorToFirebase(colorCode: colorCode, context: context)
            }

        } catch {
            print("Failed to fetch unsynced color codes: \(error)")
        }
    }

    private func uploadColorToFirebase(colorCode: ColorCode, context: ModelContext) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("ColorCodes").document(colorCode.id.uuidString)

        let data: [String: Any] = [
            "id": colorCode.id.uuidString,
            "hex": colorCode.hex,
            "createdAt": Timestamp(date: colorCode.createdAt)
        ]

        do {
            try await docRef.setData(data)
            // Update isSynced after successful upload
            colorCode.isSynced = true
            try context.save()
            print("Synced color \(colorCode.hex) to Firebase")
        } catch {
            print("Error uploading color to Firebase: \(error)")
            throw error
        }
    }
}
