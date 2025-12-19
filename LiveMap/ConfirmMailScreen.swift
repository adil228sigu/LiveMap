//
//  LoginView2.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 12.12.2025.
//

import SwiftUI

struct LoginView2: View {
    let email: String

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LoginCodeViewModel

    init(email: String) {
        self.email = email
        _viewModel = StateObject(wrappedValue: LoginCodeViewModel(email: email))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Навигация назад
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)

                    // Верхняя часть: логотип/аватар
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(width: 64, height: 64)

                    // Заголовки
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LiveMap")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)

                        Text("Мы отправили код на \(email)")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }

                    // Блок ввода кода
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Введите код подтверждения")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        OTPField(code: $viewModel.code, length: 6)
                            .padding(.top, 4)

                        Text("Введите одноразовый код, отправленный на вашу почту")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 8)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }

                    // Кнопка Подтвердить
                    Button(action: { Task { await viewModel.confirm() } }) {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white.opacity(0.9))
                            }
                            Text("Подтвердить")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(viewModel.code.count == 6 ? 1 : 0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(red: 0.42, green: 0.42, blue: 1.0))
                                .opacity(viewModel.code.count == 6 ? 1 : 0.6)
                        )
                    }
                    .disabled(viewModel.code.count != 6 || viewModel.isLoading)

                    // Ссылка "Отправить код повторно"
                    Button(action: { viewModel.resend() }) {
                        if viewModel.canResend {
                            Text("Отправить код повторно")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 1.0))
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Отправить код повторно через \(viewModel.secondsLeft) c")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!viewModel.canResend)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }
}

// MARK: - OTP Field (6 ячеек)
private struct OTPField: View {
    @Binding var code: String
    let length: Int

    @FocusState private var isFocused: Bool
    @State private var internalText: String = ""

    var body: some View {
        ZStack {
            TextField("", text: $internalText)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .foregroundColor(.clear)
                .accentColor(.clear)
                .tint(.clear)
                .disableAutocorrection(true)
                .focused($isFocused)
                .onChange(of: internalText) { _, newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    let limited = String(filtered.prefix(length))
                    if internalText != limited { internalText = limited }
                    code = limited
                }
                .onAppear {
                    internalText = code
                }
                .frame(width: 0, height: 0)
                .opacity(0.01)

            HStack(spacing: 12) {
                ForEach(0..<length, id: \.self) { i in
                    let char = character(at: i)
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .overlay(
                            Text(char.map(String.init) ?? "")
                                .font(.system(size: 24, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                        )
                        .frame(width: 48, height: 48)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }

    private func character(at index: Int) -> Character? {
        guard index < code.count else { return nil }
        let str = code
        return str[str.index(str.startIndex, offsetBy: index)]
    }
}

#Preview {
    LoginView2(email: "you@example.com")
        .preferredColorScheme(.dark)
}

