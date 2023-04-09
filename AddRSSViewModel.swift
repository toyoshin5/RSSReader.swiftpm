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
    @Published var images:[Image] = []
    @Published var accessState:CheckState = .success
    @Published var syntaxState:CheckState = .checking
    @Published var isConfirmed: Bool = false
    func onTapConfirm(){
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
                    //urlではなかったら取得しない
//                    //urlではなかったら取得しない
//                    if let srcurl = URL(string: src) {
//                        if !srcurl.absoluteString.hasPrefix("http") {
//                            return
//                        }
//                        let image = try! Data(contentsOf: srcurl)
//                        //画像の横のサイズが縦の3倍以上だったらタイトルとみなす
//                        if UIImage(data: image)!.size.width < UIImage(data: image)!.size.height * 3 {
//                            //画像を取得しない
//
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            if self.article.count > i{
//                                self.article[i].image = Image(uiImage: UIImage(data: image)!)
//                            }
//                        }
//                    }
                } catch {
                    self.syntaxState = .error
                }
            }
        
    }
}
