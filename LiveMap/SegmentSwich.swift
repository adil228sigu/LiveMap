import SwiftUI

struct SegmentSwitch: View {
    @Binding var selectedIndex: Int   // 0 = Карта, 1 = Список
    
    private let segments = ["Карта", "Список"]
    
    var body: some View {
        ZStack {
            // Общий контейнер (пилюля)
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 16/255, green: 24/255, blue: 40/255)) // #101828
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
            
            HStack(spacing: 0) {
                ForEach(segments.indices, id: \.self) { index in
                    let isSelected = index == selectedIndex
                    
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            selectedIndex = index
                        }
                    } label: {
                        ZStack {
                            if isSelected {
                                // Подложка выбранного сегмента
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 15/255, green: 23/255, blue: 38/255))
                            }
                            
                            Text(segments[index])
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(
                                    isSelected
                                    ? Color.white
                                    : Color.white.opacity(0.6)
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }
}
