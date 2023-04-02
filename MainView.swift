import SwiftUI


struct MainView: View {
    @ObservedObject var vm = MainViewModel()
    var body: some View {
        NavigationStack {
            ZStack{
                if vm.article.isEmpty{
                    //中央寄せ
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                List(vm.article, id: \.item.guid) { a in
                    NavigationLink{
                        WebView(url: a.item.link)
                    }label: {
                        VStack(alignment: .leading,spacing: 5){
                            //サイト名
                            if let image = a.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight:18)
                            }else{
                                if !a.feed.title.isEmpty{
                                    Text(a.feed.title)
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.gray)
                                }
                            }
                            if !a.item.title.isEmpty{
                                Text(a.item.title)      //記事タイトル
                                    .font(.headline)
                                    .lineLimit(2)
                            }
                            if !a.item.description.isEmpty{
                                Text(a.item.description)      //記事説明
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(4)
                            }
                            if !a.item.pubDate.isEmpty{
                                Text(a.item.pubDate)      //日付
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                }.navigationBarTitle("Articles")
                    .refreshable {
                        //配列が空で無くなるまで非同期待機
                        try! await Task.sleep(nanoseconds: 1 * 600 * 1000 * 1000)
                        repeat {
                            vm.loadData()
                            try! await Task.sleep(nanoseconds: 1 * 500 * 1000 * 1000)
                        }while vm.article.isEmpty
                        
                        
                    }
        
            }
        }.onAppear(perform: vm.loadData)
    }
}

//Preview on iPhone and iPad
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let devices = ["iPhone SE (3rd generation)", "iPhone 14 Pro"]
                ForEach(devices, id: \.self) { device in
                    MainView()
                        .previewDevice(.init(rawValue: device))
                        .previewDisplayName(device)
                }
    
    }
}


