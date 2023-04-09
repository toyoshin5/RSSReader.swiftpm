//
//  AddRSSViewModel.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/04/04.
//

import Foundation
import SwiftUI
enum CheckState{
    case error
    case checking
    case success
}

class AddRSSViewModel:ObservableObject{
    @Published var text: String = ""
    @Published var accessState:CheckState = .error
    @Published var syntaxState:CheckState = .error
    @Published var isConfirmed: Bool = false
    @Published var feedImages: [Image] = []
    @Published var selectedImageNum: Int?
    var validImageList:[Int] = []
    func onTapConfirm(){
        feedImages = []
        selectedImageNum = nil
        isConfirmed = true
        accessState = .checking
        syntaxState = .checking
        //バリデーション
        if let url: URL =  URL(string:"https://api.rss2json.com/v1/api.json?rss_url=\(text)"){
            let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                //データ取得チェック
                if let data = data {
                    //JSON→Responseオブジェクト変換
                    let decoder = JSONDecoder()
                    guard let decodedResponse = try? decoder.decode(Response.self, from: data) else {
                        print("Decode failed")
                        Task.detached{@MainActor in
                            self.accessState = .error
                            self.syntaxState = .error
                        
                        }
                        return
                        
                    }
                    if !decodedResponse.items.isEmpty{
                        let url = decodedResponse.items[0].link
                        print("OK")
                        Task.detached{@MainActor in
                            self.accessState = .success
                        }
                        self.fetchImage(url: url)
                    }else{
                        print("empty")
                    }
                
                } else {
                    //データが取得できなかった場合の処理
                    print("Fetch failed")
                    Task.detached{@MainActor in
                        self.accessState = .error
                        self.syntaxState = .error
                    }
                }
                
                
            })
            task.resume()
        }else{
            Task.detached{@MainActor in
                self.accessState = .error
                self.syntaxState = .error
            }
        }
    }
    
    private func fetchImage(url:URL){
            //非同期で最初のimgタグの画像を取得
            DispatchQueue.global().async {
                do {
                    let html = try String(contentsOf:url)
                    //正規表現で画像を取得
                    let regex = try NSRegularExpression(pattern: "<img.+?src=[\"'](.+?)[\"'].*?>", options: .caseInsensitive)
                    let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))
                    print("matches:\(matches.count)")
                    //let src = (html as NSString).substring(with: matches[0].range(at: 1))
                    if matches.count > 0{
                        Task.detached{@MainActor in
                            self.syntaxState = .success
                        }
                    }else{
                        Task.detached{@MainActor in
                            self.syntaxState = .error
                        }
                    }
                    var c = 0
                    for match in matches {
                        let src = (html as NSString).substring(with: match.range(at: 1))
                        print("src:\(src)")
                        //urlではなかったら取得しない
                        if let srcurl = URL(string: src){
                            if let image = try? Data(contentsOf: srcurl){
                                if let uiimage = UIImage(data: image){
                                    DispatchQueue.main.async {
                                        self.feedImages.append(Image(uiImage: uiimage))
                                        self.validImageList.append(c)
                                        c+=1
                                    }
                                    continue
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.validImageList.append(-1)
                        }
                    }
                } catch {
                    Task.detached{@MainActor in
                        self.syntaxState = .error
                    }
                }
            }
        
    }
    func onTapBtmButton(){
        if let num = selectedImageNum{
            //vaidImageListのなかでnumと一致する要素の添字
            let index = validImageList.firstIndex(of: num)!
            print("num:\(num) index:\(index)")
            var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
            data += text + "^" + String(index) + ","
            UserDefaults.standard.set(data, forKey: "rss_key")
            print("data",data)
        }else{
            var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
            data += text + ","
            UserDefaults.standard.set(data, forKey: "rss_key")
        }
    }
}
