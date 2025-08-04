import SwiftUI
import SpriteKit

struct SpriteKitContainerView: View {
    @State private var isRotatingLeft = false
    @State private var isRotatingRight = false
    @State private var rotationTimer: Timer?

    var body: some View {
        ZStack {
            SpriteKitView()

            VStack {
                Spacer()
                HStack(spacing: 40) {
                    // ⟲ 왼쪽 회전 버튼
                    CircleButton(label: "⟲", isActive: isRotatingLeft)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in startRotating(left: true) }
                                .onEnded { _ in stopRotating() }
                        )

                    // ⟳ 오른쪽 회전 버튼
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
        .ignoresSafeArea()
    }

    // 회전 시작
    func startRotating(left: Bool) {
        if rotationTimer == nil {
            if left {
                isRotatingLeft = true
            } else {
                isRotatingRight = true
            }

            rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                if isRotatingLeft {
                    GameScene.shared?.rotateLeft()
                } else if isRotatingRight {
                    GameScene.shared?.rotateRight()
                }
            }
        }
    }

    // 회전 정지
    func stopRotating() {
        rotationTimer?.invalidate()
        rotationTimer = nil
        isRotatingLeft = false
        isRotatingRight = false
    }
}
