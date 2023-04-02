//
//  BottomTabView.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/23.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            //メイン画面
            MainView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Articles")
                }
            //RSS一覧画面
            RSSListView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("RSS")
                }
        }
    }
}

struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}
