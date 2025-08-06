import SwiftUI
import SpriteKit

struct SpriteKitView: View {
    // ViewModel 주입, @StateObject로 하여 수명을 이 view에 종속시킴. 만약 단순히 watch만 하는 경우는 @ObservedObject
    @StateObject private var viewModel = GameViewModel(
        world: GameWorldSpec(
            backgroundColorHex: 0xFFFFFF,
            dumbbell: DumbbellSpec(startPosition: .zero), // 덤벨
            obstacles: [ //장애물
                ObstacleSpec(size: .init(width: 100, height: 20),
                             position: .init(x: 230, y: 500), isDynamic: false),
                ObstacleSpec(size: .init(width: 100, height: 20),
                             position: .init(x: 50, y: 150), isDynamic: false),
                ObstacleSpec(size: .init(width: 20, height: 120),
                             position: .init(x: 230, y: 20), isDynamic: false)
            ]
        )
    )
    // Scene을 한 번만 만들고 유지
    @State private var scene = GameScene(size: UIScreen.main.bounds.size)

    // 연속 회전 UI 상태, 가벼운건 @state로 관리
    @State private var isRotatingLeft = false
    @State private var isRotatingRight = false
    @State private var rotationTimer: Timer?


    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    // 최초 1회 바인딩
                    viewModel.bind(scene: scene)
                }
                .onDisappear {
                    // 화면 떠날 때 타이머 정리(메모리/중복 방지)
                    stopRotating()
                }

            VStack {
                Spacer()
                HStack(spacing: 40) {
                    // 왼쪽 회전 버튼
                    CircleButton(label: "⟲", isActive: isRotatingLeft)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in startRotating(left: true) }
                                .onEnded { _ in stopRotating() }
                        )
                    
                    // 오른쪽 회전 버튼
                    CircleButton(label: "⟳", isActive: isRotatingRight)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in startRotating(left: false) }
                                .onEnded { _ in stopRotating() }
                        )
                }
                .padding(.bottom, 40)
            }
        }
    }

    
    private func startRotating(left: Bool) {
        // 씬 바인딩 전/이미 동작 중이면 시작하지 않음
        guard rotationTimer == nil, viewModel.scene != nil else { return }

        if left { isRotatingLeft = true } else { isRotatingRight = true }

        rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            if isRotatingLeft {
                viewModel.rotateLeft()
            } else if isRotatingRight {
                viewModel.rotateRight()
            }
        }
        // 스크롤/제스처 중에도 동작하도록 런루프 모드 추가(선택)
        RunLoop.main.add(rotationTimer!, forMode: .common)
    }

    private func stopRotating() {
        rotationTimer?.invalidate()
        rotationTimer = nil
        isRotatingLeft = false
        isRotatingRight = false
    }
}
