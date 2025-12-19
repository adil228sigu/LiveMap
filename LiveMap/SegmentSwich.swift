import SwiftUI

struct SegmentSwitch: View {
    @Binding var selectedIndex: Int   // 0 = Карта, 1 = Список
    
    private let segments = ["Карта", "Список"]
    
    var body: some View {
        ZStack {
            Picker(selection: $selectedIndex, content: {
                
            }, label: {
                Text(segments.first ?? "")
            }).pickerStyle(.segmented)
            
            
        }
    }
}
