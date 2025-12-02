import SwiftUI

struct MapScreenVIew: View {
    @State private var segmentIndex = 0
    
    @State private var zoom: Float = 12

    var body: some View {
        VStack(spacing: 16) {
            SegmentSwitch(selectedIndex: $segmentIndex)
                .padding(.top , 15)
            
            if segmentIndex == 0 {
                ZStack(alignment: .bottomTrailing) {
                    GoogleMapView(zoom: $zoom)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                    VStack(spacing: 16){
                        MapControlButton(systemName: "plus", action: {
                            if zoom < 20 { zoom += 1 }
                        })
                        MapControlButton(systemName: "minus", action: {
                            if zoom > 2 { zoom -= 1 }
                        })
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 32)
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .frame(height: 650)
                .padding(.horizontal, 16)
                Spacer()
            } else {
                List {
                    Text("1")
                    Text("2")
                    Text("3")
                }
                .listStyle(.plain)
            }
            

           
        }
        .background(
            Color(red: 16/255, green: 24/255, blue: 40/255)
                .ignoresSafeArea()
        )

    }
}

