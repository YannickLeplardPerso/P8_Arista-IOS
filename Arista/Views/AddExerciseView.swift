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
                            Text(category.rawValue)
                                .foregroundColor(.blue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    TextField("Heure de démarrage", text: Binding(
                        get: { viewModel.getStartTimeString()},
                        set: { viewModel.setStartTime(from: $0)}
                    ))
                    .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Durée (en minutes)")
                        Stepper(value: $viewModel.duration, in: 0...4320, step: 1) {
                            Text("\(viewModel.duration)")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Intensité (1 à 10)")
                        Slider(value: Binding(
                            get: { Double(viewModel.intensity) },
                            set: { viewModel.intensity = Int($0) }
                        ), in: 1...10, step: 1)
                        Text("\(viewModel.intensity)") // Display the current value
                            .foregroundColor(.blue)
                    }
                }.formStyle(.grouped)
                Spacer()
                HStack {
                    Button("Ajouter l'exercice") {
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
