import SwiftUI
import SpriteKit

struct SpriteKitView: View {
    var scene: SKScene { // computed property -> customizing 된 SKScene 인스턴스를 필요로 하기 때문
        let scene = GameScene() // GameScene 인스턴스 생성
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // Scene의 크기를 화면에 맞춤
        scene.scaleMode = .resizeFill // Scene이 화면에 꽉 차도록 자동 조정
        return scene
    }

    var body: some View {
        SpriteView(scene: scene) // 이렇게 computed property로 만들어야 body를 다시 그리는 경우 "필요할 때만" scene을 새로 계산함. 리빌드 성능 개선 효과
            .ignoresSafeArea()
    }
}
