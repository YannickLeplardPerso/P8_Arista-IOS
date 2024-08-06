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
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Catégorie", selection: $viewModel.category) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    //TextField("Catégorie", text: $viewModel.category)
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
                HStack {
                    Button("Ajouter l'exercice") {
                        // TODO : tester addExercise et afficher erreur
                        do {
                            try viewModel.addExercise()
                            presentationMode.wrappedValue.dismiss()
                        }
                        catch let error as AristaError {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        } catch {
                            alertMessage = "Unexpected error: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }.buttonStyle(.borderedProminent)
                    
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Nouvel Exercice ...")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
