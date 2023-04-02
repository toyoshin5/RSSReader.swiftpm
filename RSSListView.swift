//
//  RSSListView.swift
//  マイApp
//
//  Created by Shin Toyo on 2023/03/23.
//

import SwiftUI

struct RSSListView: View {
    @ObservedObject var vm = RSSListViewModel()
    var body: some View {
        // リストを表示
        NavigationStack {
            List{
                ForEach(vm.rssList) { item in
                    VStack(alignment: .leading) {
                        Text(item.url)
                            .font(.headline)
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
                                .presentationDetents([.medium,.large])
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
