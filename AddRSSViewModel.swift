//
//  AddRSSViewModel.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/04/04.
//

import Foundation
class AddRSSViewModel:ObservableObject{
    @Published var text: String = ""
    func onTapAdd(){
        //バリデーション
        if text.range(of: "[^a-zA-Z0-9/.:_-]", options: .regularExpression) == nil {
            var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
            
            data += text + ","
            UserDefaults.standard.set(data, forKey: "rss_key")
        }
    }
}
