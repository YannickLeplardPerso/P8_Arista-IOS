//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    
    var body: some View {
        
        if let error = viewModel.error {
            Text(error.localizedDescription)
                .foregroundColor(.red)
                .padding()
            
        } else {
            List(viewModel.sleepSessions) { session in
                HStack {
                    QualityIndicator(quality: session.quality)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Début : \(session.startDate?.formatted() ?? "?")")
                        Text("Durée : \(session.duration/60) heures")
                    }
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue, .white]),
                                   startPoint: .trailing,
                                   endPoint: .leading)
                )
                .cornerRadius(10) // Make the corners rounded
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
            }
            .navigationTitle("Historique de Sommeil")
        }
    }
}

struct QualityIndicator: View {
    let quality: Int64

    var body: some View {
        ZStack {
            Circle()
                .stroke(qualityColor(quality), lineWidth: 5)
                .foregroundColor(qualityColor(quality))
                .frame(width: 30, height: 30)
            Text("\(quality)")
                .foregroundColor(qualityColor(quality))
        }
    }

    func qualityColor(_ quality: Int64) -> Color {
        switch (10-quality) {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
