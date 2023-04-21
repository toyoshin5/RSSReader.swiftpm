import SwiftUI
@main
struct MyApp: App {
    
    init(){
        switch LaunchUtil.launchStatus {
            case .FirstLaunch : //初回起動
                UserDefaults.standard.set("https://news.yahoo.co.jp/rss/topics/top-picks.xml^1,", forKey: "rss_key")
        case .NewVersionLaunch : break //更新時
        case .Launched: break //通常起動
        }
    }
    var body: some Scene {
        WindowGroup {
            BottomTabView()
        }
    }
}

//Preview
struct MyApp_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}

