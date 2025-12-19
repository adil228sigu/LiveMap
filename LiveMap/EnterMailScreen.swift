//
//  LoginView.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 12.12.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginEmailViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Верхняя часть: логотип + аватар-заглушка
                    HStack(alignment: .top, spacing: 16) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 64, height: 64)
                    }
                    .padding(.top, 16)

                    // Заголовок и подзаголовок
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LiveMap")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)

                        Text("Давай продолжим")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Почта")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        HStack {
                            TextField("", text: $viewModel.email, prompt: Text("например, you@example.com").foregroundColor(.gray))
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .fill(Color(white: 0.18))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color(white: 0.18), lineWidth: 1)
                        )
                    }
                    .padding(.top, 24)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }

                    // Кнопка "Продолжить" -> отправка кода + открыть LoginView2
                    Button(action: {
                        Task { await viewModel.sendCode() }
                    }) {
                        HStack(spacing: 8) {
                            if viewModel.isLoading { ProgressView().tint(.white) }
                            Text("Продолжить")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(red: 0.42, green: 0.42, blue: 1.0))
                            .opacity(viewModel.isLoading ? 0.7 : 1.0)
                    )
                    .disabled(viewModel.isLoading || !viewModel.isValidEmail(viewModel.email))
                    .contentShape(Rectangle())
                    .sheet(isPresented: $viewModel.shouldShowCodeSheet) {
                        LoginView2(email: viewModel.email)
                            .preferredColorScheme(.dark)
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    LoginView()
        .preferredColorScheme(.dark)
}

