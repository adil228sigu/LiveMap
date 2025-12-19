import SwiftUI

struct ProfileSetupView: View {
    let email: String
    var onFinish: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var nickname: String = ""
    @State private var birthDate: Date? = nil
    @State private var countryCity: String = ""

    @FocusState private var focusedField: Field?
    @State private var showDatePicker: Bool = false

    private enum Field: Hashable {
        case nickname, countryCity
    }

    private let primary = Color(red: 0.42, green: 0.42, blue: 1.0)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

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

                    // Аватар-заглушка
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(width: 64, height: 64)
                        .padding(.top, 12)

                    // Заголовки
                    VStack(alignment: .leading, spacing: 6) {
                        Text("LiveMap")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)

                        Text("Расскажи чуть-чуть о себе")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 12)

                    // Никнейм
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Никнейм")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        CapsuleField {
                            TextField("", text: $nickname,
                                      prompt: Text("например, alex_21").foregroundColor(.gray))
                                .textInputAutocapitalization(.none)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                                .keyboardType(.asciiCapable)
                                .focused($focusedField, equals: .nickname)
                                .onChange(of: nickname) { _, new in
                                    nickname = sanitizedNickname(new)
                                }
                        }

                        Text("От 3 до 20 символов. Можно буквы, цифры и “_”")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }
                    .padding(.top, 24)

                    // Дата рождения
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Дата рождения")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        Button {
                            focusedField = nil
                            showDatePicker.toggle()
                        } label: {
                            CapsuleFieldContent {
                                HStack(spacing: 8) {
                                    Text(formattedDate(birthDate) ?? "дд.мм.гггг")
                                        .foregroundColor(formattedDate(birthDate) == nil ? .gray : .white)
                                        .font(.system(size: 17))
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 22)

                    // Страна / город
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Страна / город")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        CapsuleField {
                            TextField("", text: $countryCity,
                                      prompt: Text("например, Казахстан, Алматы").foregroundColor(.gray))
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(false)
                                .foregroundColor(.white)
                                .focused($focusedField, equals: .countryCity)
                        }
                    }
                    .padding(.top, 22)

                    // Кнопка завершить
                    Button(action: {
                        onFinish?()
                    }) {
                        Text("Завершить регистрацию")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white.opacity(isValid ? 1 : 0.9))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(primary)
                            .opacity(isValid ? 1 : 0.6)
                    )
                    .disabled(!isValid)
                    .padding(.top, 28)

                    Spacer(minLength: 12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
                .padding(.top, 6)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selected: Binding(
                get: { birthDate ?? Date(timeIntervalSince1970: 0) },
                set: { birthDate = $0 }
            ))
            .presentationDetents([.height(340)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Валидация
    private var isValid: Bool {
        isNicknameValid(nickname) && birthDate != nil && !countryCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func isNicknameValid(_ s: String) -> Bool {
        let len = s.count
        guard (3...20).contains(len) else { return false }
        // Разрешены латиница, цифры, _
        return s.range(of: "^[A-Za-z0-9_]+$", options: .regularExpression) != nil
    }

    private func sanitizedNickname(_ s: String) -> String {
        let filtered = s.filter { $0.isLetter || $0.isNumber || $0 == "_" }
        return String(filtered.prefix(20))
    }

    private func formattedDate(_ date: Date?) -> String? {
        guard let date else { return nil }
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "dd.MM.yyyy"
        return df.string(from: date)
    }
}

// MARK: - Капсульные поля (как на макете)
private struct CapsuleField<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        CapsuleFieldContent { content }
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(white: 0.18))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color(white: 0.18), lineWidth: 1)
            )
    }
}

private struct CapsuleFieldContent<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        HStack {
            content
                .padding(.horizontal, 20)
                .padding(.vertical, 14) // чуть компактнее, чтобы визуально как на макете
        }
    }
}

// MARK: - Лист с DatePicker
private struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date
    let onChange: (Date) -> Void

    init(selected: Binding<Date>) {
        _date = State(initialValue: selected.wrappedValue)
        self.onChange = { selected.wrappedValue = $0 }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Выберите дату")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 8)

            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorScheme(.dark)
                .tint(.white)
                .environment(\.locale, Locale(identifier: "ru_RU"))
                .padding(.horizontal, 4)

            Button("Готово") {
                onChange(date)
                dismiss()
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 0.42, green: 0.42, blue: 1.0))
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .padding(.bottom, 16)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ProfileSetupView(email: "you@example.com")
        .preferredColorScheme(.dark)
}
