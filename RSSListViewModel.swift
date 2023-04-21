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
        print(data)
        let rssListData = data.split(separator: ",")
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
    //urlから^以降を削除する関数
    func deleteParam(url: String) -> String{
        var newUrl = url
        if let index = url.firstIndex(of: "^"){
            newUrl = String(url[..<index])
        }
        return newUrl
    }
    func showCopiedAlert(){
        let alert = UIAlertController(title: "コピーしました", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        //alertを表示
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    
    
    
    }


}
