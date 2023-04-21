//
//  RSSListView.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/23.
//

import SwiftUI

struct RSSListView: View {
    @StateObject var vm = RSSListViewModel()
    var body: some View {
        // リストを表示
        NavigationStack {
            List{
                ForEach(vm.rssList) { item in
                    VStack(alignment: .leading) {
                        Text(vm.deleteParam(url: item.url))
                            .font(.headline)
                    }.onTapGesture {
                        //コピー
                        UIPasteboard.general.string = vm.deleteParam(url: item.url)
                        //コピーしましたを表示
                        vm.showCopiedAlert()
                    }
                }.onDelete(perform: vm.rowRemove)
            }.onAppear {
                vm.getRSSList()
            }.navigationTitle("RSS List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //下から出てくるモーダルを表示
                            vm.showModal.toggle()
                        } label: {
                            Image(systemName: "plus").imageScale(.large)
                        }.sheet(isPresented: $vm.showModal,
                                onDismiss: {
                            vm.getRSSList()
                        }
                        ) {
                            AddRSSView()
                                .presentationDetents([.height(600),.large])
                        }
                    }
                }
        }.onAppear(perform: vm.getRSSList)
    }
    
}

struct RSSListView_Previews: PreviewProvider {
    static var previews: some View {
        RSSListView()
    }
}
