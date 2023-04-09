//
//  AddRSSView.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/04/01.
//

import SwiftUI

struct AddRSSView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = AddRSSViewModel()
    var body: some View {
        //URLを入力するページ
        VStack (alignment: .leading) {
            Text("Subscribe")
                .font(.title)
                .bold()
            Text("RSSのURLを入力してください")
            HStack{
                TextField("URL", text: self.$vm.text)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 2.0)
                            .padding(-14.0)
                    )
                    .padding(8.0)
                Button(action: {
                    vm.onTapConfirm()
                    //dismiss()
                }) {
                    Text("Confirm")
                        .bold()
                        .padding()
                        .frame(width: 100)
                        .foregroundColor(Color(.systemBackground))
                        .background(Color(.label))
                        .cornerRadius(10)
                }
            }
            Divider()
            if vm.isConfirmed{
                ValidationView(checkState: $vm.accessState
                               , checkMsg: "記事の取得を確認中...", successMsg: "記事を取得可能です", errorMsg: "記事を取得できませんでした")
                ValidationView(checkState: $vm.syntaxState,
                               checkMsg: "記事のサムネイルを確認中...", successMsg: "記事のサムネイルを利用可能です", errorMsg: "記事のサムネイルは利用できません")
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

struct ValidationView: View {
    @Binding var checkState: CheckState
    var checkMsg:String
    var successMsg:String
    var errorMsg:String
    var body: some View {
        HStack{
            if checkState == .checking{
                ProgressView()
                    .padding(
                        EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 2)
                        )
                    .frame(height: 20)
                Text(checkMsg)
            }else if checkState == .success{
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                    .frame(height: 20)
                Text(successMsg)
            }else if checkState == .error{
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .frame(height: 20)
                Text(errorMsg)
            }
        }
    }
}
