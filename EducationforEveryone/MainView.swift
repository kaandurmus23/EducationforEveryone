import SwiftUI

struct MainView: View {
    var firebaseuid : String
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CounterView()
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Sayaç")
                }
                .tag(0)
            
            CourseView(firebaseuid: firebaseuid)
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Kurs Oluştur/Başvur")
                }
                .tag(1)
            
            MessageListView(firebaseid: firebaseuid)
                .tabItem {
                    Image(systemName: "message")
                    Text("Mesajlar")
                }
                .tag(2)
        }
    
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(firebaseuid: "123")
    }
}
