//
//  MainModel.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/14.
//

import SwiftUI

//RSS情報をまとめる構造体
struct Response: Codable {
    let feed: Feed
    let items: [Result]
}
struct Feed:Codable{
    let title: String
    let link: URL
}
//記事詳細
struct Result: Codable {
    let title: String
    let link: URL
    let guid: String
    let pubDate: String
    let description: String
}
struct Article{
    let item: Result
    let feed: Feed
    var image:Image?
}




