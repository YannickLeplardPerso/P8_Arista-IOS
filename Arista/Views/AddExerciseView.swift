//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Catégorie", text: $viewModel.category)
                    TextField("Heure de démarrage", text: Binding(
                        get: { viewModel.getStartTimeString()},
                        set: { viewModel.setStartTime(from: $0)}
                    ))
                    TextField("Durée (en minutes)", text: Binding(
                        get: { viewModel.durationString },
                        set: { viewModel.durationString = $0 }
                    ))
                    TextField("Intensité (0 à 10)", text: Binding(
                        get: { viewModel.intensityString },
                        set: { viewModel.intensityString = $0 }
                    ))
                }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
