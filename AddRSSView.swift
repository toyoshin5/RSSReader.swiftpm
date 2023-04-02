//
//  AddRSSView.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/04/01.
//

import SwiftUI

struct AddRSSView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String = ""
    var body: some View {
        //URLを入力するページ
        VStack (alignment: .leading) {
            Text("Subscribe")
                .font(.title)
                .bold()
            Text("RSSのURLを入力してください")
            HStack{
                TextField("URL", text: self.$text)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 2.0)
                            .padding(-14.0)
                    )
                    .padding(8.0)
                Button(action: {
                    //バリデーション
                    //データが英数字と.と/だけだったら追加
                    if text.range(of: "[^a-zA-Z0-9/.:_-]", options: .regularExpression) == nil {
                        var data = UserDefaults.standard.string(forKey: "rss_key") ?? ""
                        
                        data += text + ","
                        UserDefaults.standard.set(data, forKey: "rss_key")
                        dismiss()
                    }
                
                }) {
                    Text("追加")
                        .bold()
                        .padding()
                        .frame(width: 100)
                        .foregroundColor(Color(.systemBackground))
                        .background(Color(.label))
                        .cornerRadius(10)
                }
            }
            Spacer()
        }.padding()
    }
}
struct AddRSSView_Previews: PreviewProvider {
    static var previews: some View {
        AddRSSView()
    }
}
