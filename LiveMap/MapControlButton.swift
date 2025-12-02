import SwiftUI


struct MapControlButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)                     // белая иконка
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)       // прямоугольник как на макете
                        .fill(Color.black.opacity(0.6))
                )
        }
        .buttonStyle(.plain)                                 // отключаем системный .tint
    }
}
