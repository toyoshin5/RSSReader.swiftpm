import SwiftUI
@main
struct MyApp: App {
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

