import Combine

final class GameViewModel: ObservableObject {
    @Published var world: GameWorldSpec

    init(world: GameWorldSpec) {
        self.world = world
    }

    // 씬에 전달할 의도
    weak var scene: GameScene?

    func bind(scene: GameScene) {
        self.scene = scene
        scene.configure(with: world) // 최초 1회 구성
    }

    // 입력 처리 예시
    func rotateLeft()  { scene?.rotateLeft() }
    func rotateRight() { scene?.rotateRight() }

    // 동적으로 스펙이 바뀌면 씬 갱신
    func applyWorldUpdate() {
        scene?.configure(with: world)
    }
}
