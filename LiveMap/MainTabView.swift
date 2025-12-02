//
//  MainTabView.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 1.12.2025.
//

import SwiftUI

struct MainTabView: View {
    
    
    
    
    var body: some View {
        TabView{
            MapScreenVIew()
                .tabItem{
                    Image(systemName: "globe.asia.australia.fill")
                    Text("Карта")
                }
            Text("Стрим")
                .tabItem{
                    Image(systemName: "plus.circle")
                    Text("Стрим")
                }
            Text("Подписки")
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("Подписки")
                }
             Text("Profile")
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("Profile")
                            }
        }
        .tint(Color.purple)
    }
}


