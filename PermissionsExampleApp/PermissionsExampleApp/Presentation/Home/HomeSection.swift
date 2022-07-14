//
//  HomeSection.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import Foundation

enum HomeSection {
    case general(_ generalRows: [GeneralRow])
}

enum GeneralRow {
    case camera

    var title: String {
        switch self {
        case .camera:
            return "Camera"
        }
    }
}
