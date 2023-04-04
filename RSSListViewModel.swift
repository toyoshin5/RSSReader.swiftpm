//
//  RSSListViewModel.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/23.
//

import SwiftUI

class RSSListViewModel: ObservableObject{
    @Published var showModal = false
    @Published var rssList: [RSSListModel] = []
    func getRSSList(){
        rssList = []
        var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
        if !data.isEmpty{
            data.removeLast()
        }
        let rssListData = data.split(separator: ",")
        print(data)
        for rssData in rssListData{
            let rss = RSSListModel(url: String(rssData))
            rssList.append(rss)
        }
    }
    func rowRemove(offsets: IndexSet) {
        rssList.remove(atOffsets: offsets)
        var data = ""
        for rss in rssList{
            data += rss.url + ","
        }
        UserDefaults.standard.set(data, forKey: "rss_key")
    }
}
