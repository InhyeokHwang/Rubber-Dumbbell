import SwiftUI

@main
struct RubberDumbbellApp: App { // App Protocol
    var body: some Scene { // Scene은 하나의 UI 세션, 일반적으로 하나만 존재 (창 단위)
        WindowGroup { // 사용자에게 보이는 UI 뷰 트리를 시작하는 컨테이너
            SpriteKitView() // 첫 화면
        }
    }
}
