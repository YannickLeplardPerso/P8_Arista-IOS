//
//  ExerciseList.swift
//  Arista
//
//  Created by Yannick LEPLARD on 04/08/2024.
//

import Foundation

enum ExerciseCategory: String, CaseIterable {
    case football = "Football"
    case natation = "Natation"
    case running = "Running"
    case marche = "Marche"
    case cyclisme = "Cyclisme"

    var iconName: String {
        switch self {
        case .football:
            return "sportscourt"
        case .natation:
            return "waveform.path.ecg"
        case .running:
            return "figure.run"
        case .marche:
            return "figure.walk"
        case .cyclisme:
            return "bicycle"
        }
    }
}
