//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationView {
            List(viewModel.exercises) { exercise in
                HStack {
                    if let category = ExerciseCategory(rawValue: exercise.category!) {
                        Image(systemName: category.iconName)
                    }
                    VStack(alignment: .leading) {
                        Text(exercise.category ?? "?")
                            .font(.headline)
                        Text("Durée: \(exercise.duration) min")
                            .font(.subheadline)
                        Text(exercise.startDate?.formatted() ?? "?")
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    IntensityIndicator(intensity: exercise.intensity)
                }
            }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
                .onDisappear() {
                    viewModel.reload()
                }
        }
//        .onAppear() {
//            viewModel.reload()
//        }
        
    }
}

struct IntensityIndicator: View {
    var intensity: Int64
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    func colorForIntensity(_ intensity: Int64) -> Color {
        switch intensity {
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
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
