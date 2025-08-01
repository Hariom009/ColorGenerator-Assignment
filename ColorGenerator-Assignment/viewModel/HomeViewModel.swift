//
//  HomeViewModel.swift
//  ColorGenerator-Assignment
//
//  Created by Hari's Mac on 01.08.2025.
//

import SwiftData
import SwiftUI

class HomeViewModel: ObservableObject {
    
    func generateRandomColor(context: ModelContext) {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)

        let hex = String(format: "#%02X%02X%02X",
                         Int(red * 255),
                         Int(green * 255),
                         Int(blue * 255))

        let newColorCode = ColorCode(hex: hex)
        context.insert(newColorCode)
    }
}
