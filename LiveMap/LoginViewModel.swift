//
//  LoginViewModel.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 13.12.2025.
//

import Foundation

@MainActor
final class LoginEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var shouldShowCodeSheet: Bool = false

    func isValidEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".")
    }

    func sendCode() async {
        guard isValidEmail(email) else { return }
        isLoading = true
        errorMessage = nil
        do {
            let response = try await NetworkManager.shared.sendCode(email: email)
            if response.success {
                shouldShowCodeSheet = true
            } else {
                errorMessage = "Не удалось отправить код."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

@MainActor
final class LoginCodeViewModel: ObservableObject {
    let email: String

    // Ввод кода
    @Published var code: String = ""

    // Состояния
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // resend
    @Published var canResend: Bool = false
    @Published var secondsLeft: Int = 60

    private var timer: Timer?

    init(email: String) {
        self.email = email
    }

    func onAppear() {
        startResendTimer()
    }

    func onDisappear() {
        stopResendTimer()
    }

    func resend() {
        Task {
            do {
                _ = try await NetworkManager.shared.sendCode(email: email)
                startResendTimer()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func confirm() async {
        guard code.count == 6 else { return }
        isLoading = true
        errorMessage = nil
        do {
            // TODO: заменить на verify endpoint, когда появится в NetworkManager.
            try await Task.sleep(nanoseconds: 300_000_000)
            // На успехе можно отправить событие навигации/закрытия, если требуется
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func startResendTimer() {
        canResend = false
        secondsLeft = 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            guard let self else { return }
            if self.secondsLeft > 0 {
                self.secondsLeft -= 1
            } else {
                self.canResend = true
                t.invalidate()
            }
        }
    }

    private func stopResendTimer() {
        timer?.invalidate()
        timer = nil
    }
}

