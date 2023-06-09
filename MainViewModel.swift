//
//  MainViewModel.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/14.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var article = [Article]()
    
    func loadData() {
        Task.detached {
            @MainActor in
            self.article = []
        }
        let dispatchGroup = DispatchGroup()
        //取得したいRSSを指定
        var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
        if !data.isEmpty{
            data.removeLast()
        }
        let rssList = data.components(separatedBy: ",")
        for _ in 0..<rssList.count{dispatchGroup.enter()}
        for rss in rssList {
            //^がある場合は、その後ろの数字を変数に代入して、rssの^以降を削除
            var r = rss
            var num:Int?
            if rss.contains("^"){
                let index = rss.firstIndex(of: "^")!
                num = Int(rss[index...].dropFirst())
                r = String(rss[..<index])
            }
            let thumbnailNum = num
            
            //指定したRSSをJSONに変換するAPIと連結して取得する
                let url: URL =  URL(string:"https://api.rss2json.com/v1/api.json?rss_url=\(r)")!
            Task{
                do{
                    let (data,_) = try await URLSession.shared.data(from: url)
                        //JSON→Responseオブジェクト変換
                        let decoder = JSONDecoder()
                        guard let decodedResponse = try? decoder.decode(Response.self, from: data) else {
                            print("Decode failed")
                            //アラートを出す
                            
                            return
                        }
                        //RSS情報をUIに適用
                        let items = decodedResponse.items
                        let feed = decodedResponse.feed
                        Task{
                            @MainActor in
                            for item in items {
                                self.article.append(Article(item: item, feed: feed,thumbnailNum: thumbnailNum))
                            }
                            dispatchGroup.leave()
                            
                        }
                }catch{
                    //データが取得できなかった場合の処理
                    print("クライアントエラー: \(error.localizedDescription)")
                }
            }
        }
        //dispatchGroupが終わったら実行
        dispatchGroup.notify(queue: .main){
            //pubDateが新しい順に並べる
            self.sorting()
            //非同期で画像を取得
            self.fetchImage()
        }
    }
    private func sorting(){

        var oldList = self.article
        print(oldList.count)
        var newList = [Article]()
        //pubDateが新しい順に並べる
        while oldList.count > 0 {
            var max = 0
            for i in 0..<oldList.count {
                if oldList[i].item.pubDate > oldList[max].item.pubDate {
                    max = i
                }
            }
            newList.append(oldList[max])
            oldList.remove(at: max)
        }
        
        self.article = newList
    }
    private func fetchImage(){
        for i in 0..<self.article.count {
            let url = self.article[i].item.link
            //非同期で最初のimgタグの画像を取得
            DispatchQueue.global().async {
                do {
                    let html = try String(contentsOf: url)
                    //正規表現で画像を取得(ここ激ヤバ)
                    let regex = try NSRegularExpression(pattern: "<img.+?src=[\"'](.+?)[\"'].*?>", options: .caseInsensitive)
                    let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))
                    let src1 = (html as NSString).substring(with: matches[0].range(at: 1))
                    //urlではなかったら取得しない
                    if let srcurl = URL(string: src1) {
                        if !srcurl.absoluteString.hasPrefix("http") {
                            return
                        }
                        let image = try Data(contentsOf: srcurl)
                        //画像の横のサイズが縦の3倍以上だったらタイトルとみなす
                        if let uiimg = UIImage(data: image){
                            if uiimg.size.width > UIImage(data: image)!.size.height * 3 {
                                DispatchQueue.main.async {
                                    if self.article.count > i{
                                        self.article[i].image = Image(uiImage: UIImage(data: image)!)
                                    }
                                }
                            }
                        }
                    }
                    //thumbnailDictの値があれば、その番号の画像を取得
                    if let num = self.article[i].thumbnailNum {
                            let src2 = (html as NSString).substring(with: matches[num].range(at: 1))
                            if let srcurl = URL(string: src2) {
                                if !srcurl.absoluteString.hasPrefix("http") {
                                    return
                                }
                                if let image = try? Data(contentsOf: srcurl){
                                    DispatchQueue.main.async {
                                        if self.article.count > i{
                                            self.article[i].thumbnail = Image(uiImage: UIImage(data: image)!)
                                        }
                                    }
                                }
                            }
                        }
            
                } catch {
                    print(error)
                }
            }
        }
    }
}

