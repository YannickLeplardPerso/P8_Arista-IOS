//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Spacer()
                Text("Bonjour")
                    .font(.title)
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .padding()
                    
                } else {
                    Text("\(viewModel.firstName) \(viewModel.lastName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .scaleEffect(1.2)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
                }
                Spacer()
            }
        }
    }
}

#Preview {
    UserDataView(viewModel: UserDataViewModel(context: PersistenceController.preview.container.viewContext))
}
