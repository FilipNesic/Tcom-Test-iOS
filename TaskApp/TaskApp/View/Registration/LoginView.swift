//
//  ContentView.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var email = "filip.nesic.developer@gmail.com"
    @State private var navigateOnMain = false
    @State private var token: String?
    @ObservedObject private var viewModel = DataProviderModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 35) {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 100)
                Text("Tcom Test Login")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 55)
                    .foregroundStyle(Color.gray)
                    .opacity(0.6)
                    .overlay {
                        TextField("", text: $email, prompt: Text("Unesite email").foregroundColor(.gray))
                            .padding()
                            .foregroundStyle(Color.white)
                    }
                Spacer()
                
                Button(action: {
                    viewModel.generateToken()
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 45)
                        .foregroundStyle(Color.blue)
                        .overlay {
                            Text("Prijavi se")
                                .foregroundStyle(Color.white)
                                .font(.headline)
                        }
                })
                .padding(.bottom, 10)
            }
        }
        .onReceive(viewModel.$tokenIsValid, perform: { isTokenValidValue in
            navigateOnMain = isTokenValidValue
        })
        .fullScreenCover(isPresented: $navigateOnMain, content: {
            MainRootView()
        })
    }
}
