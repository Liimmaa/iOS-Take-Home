//
//  ColorProvider.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 20/01/2022.
//

import UIKit

struct ColorProvider {
    private let colors: [UIColor] = [.systemPink, .systemBlue, .systemGreen, .systemOrange, .systemPurple] 
    
    func getColorByIndex(indexPath: IndexPath) -> UIColor {
        self.colors[indexPath.row % self.colors.count]
    }
}
