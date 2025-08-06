import SpriteKit

final class GameScene: SKScene {

    // View 전용 상태
    private var dumbbellNode: SKNode?
    private var worldSpec: GameWorldSpec?

    // 외부에서 Model을 주입받아 Scene을 구성
    func configure(with spec: GameWorldSpec) {
        self.worldSpec = spec
        rebuildScene()
    }

    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // 화면 경계
    }

    // MARK: - Build
    private func rebuildScene() {
        guard let spec = worldSpec else { return }

        // 기존 노드 정리 후 다시 빌드 (View 책임)
        removeAllChildren()

        // 배경색
        self.backgroundColor = UIColor(
            red: CGFloat((spec.backgroundColorHex >> 16) & 0xFF) / 255.0,
            green: CGFloat((spec.backgroundColorHex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(spec.backgroundColorHex & 0xFF) / 255.0,
            alpha: 1.0
        )

        // 경계는 유지
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // 덤벨
        let dumbbell = makeDumbbell(from: spec.dumbbell)
        addChild(dumbbell)
        dumbbellNode = dumbbell

        // 장애물
        for obs in spec.obstacles {
            addChild(makeObstacle(from: obs))
        }
    }

    private func makeDumbbell(from spec: DumbbellSpec) -> SKNode {
        let node = SKNode()
        
        node.position = spec.startPosition == .zero
        ? CGPoint(x: frame.midX, y: frame.midY)
        : spec.startPosition

        // 파츠
        let leftWeight = SKSpriteNode(color: .darkGray, size: spec.leftSize)
        leftWeight.position = CGPoint(x: -70, y: 0)

        let rightWeight = SKSpriteNode(color: .darkGray, size: spec.rightSize)
        rightWeight.position = CGPoint(x: 70, y: 0)

        let handle = SKSpriteNode(color: .gray, size: spec.handleSize)
        handle.position = .zero

        node.addChild(leftWeight)
        node.addChild(rightWeight)
        node.addChild(handle)

        // 물리 바디 합성
        let leftBody   = SKPhysicsBody(rectangleOf: spec.leftSize, center: leftWeight.position)
        let rightBody  = SKPhysicsBody(rectangleOf: spec.rightSize, center: rightWeight.position)
        let handleBody = SKPhysicsBody(rectangleOf: spec.handleSize, center: handle.position)
        let body = SKPhysicsBody(bodies: [leftBody, rightBody, handleBody])

        body.restitution = spec.restitution
        body.angularDamping = spec.angularDamping
        body.linearDamping = spec.linearDamping
        body.friction = spec.friction
        body.allowsRotation = true
        body.angularVelocity = spec.initialAngularVelocity

        node.physicsBody = body
        return node
    }
    
    private func makeObstacle(from spec: ObstacleSpec) -> SKNode {
        let node = SKSpriteNode(color: .black, size: spec.size)
        node.position = spec.position
        node.physicsBody = SKPhysicsBody(rectangleOf: spec.size)
        node.physicsBody?.isDynamic = spec.isDynamic
        return node
    }

    // 키 입력 또는 버튼 처리에 따라 회전 방향 조정도 가능
    func rotateLeft() {
        dumbbellNode?.physicsBody?.applyAngularImpulse(0.2)
    }

    func rotateRight() {
        dumbbellNode?.physicsBody?.applyAngularImpulse(-0.2)
    }
    
    // update는 SKScene 클래스에 정의돼 있음. 이런 구조 open func update(_ currentTime: TimeInterval) { }, open은 swift의 access control키워드 중 하나이며 가장 개발적인 접근 수준
    override func update(_ currentTime: TimeInterval) {
        guard
            let body = dumbbellNode?.physicsBody,
            let max = worldSpec?.limits.maxAngularVelocity
        else { return }

        if body.angularVelocity > max {
            body.angularVelocity = max
        } else if body.angularVelocity < -max {
            body.angularVelocity = -max
        }
    }
}
