import SpriteKit

class GameScene: SKScene { // SKScene을 상속받아서 구현
    static var shared: GameScene?
    
    private var dumbbell: SKNode! // 덤벨 노드

    override func didMove(to view: SKView) {
        self.backgroundColor = .white // scene의 배경을 흰색으로 설정
        GameScene.shared = self  // 반드시 있어야 외부에서 접근 가능

        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) // 화면 경계 (충돌 경계)

        addDumbbell() // 덤벨을 생성
        addObstacles() // 장애물 생성
    }

    func addDumbbell() {
        dumbbell = SKNode()
        dumbbell.position = CGPoint(x: frame.midX, y: frame.midY)

        // 왼쪽 weight
        let leftWeight = SKSpriteNode(color: .darkGray, size: CGSize(width: 40, height: 80))
        leftWeight.position = CGPoint(x: -70, y: 0)

        // 오른쪽 weight
        let rightWeight = SKSpriteNode(color: .darkGray, size: CGSize(width: 40, height: 80))
        rightWeight.position = CGPoint(x: 70, y: 0)

        // 핸들
        let handle = SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 20))
        handle.position = CGPoint.zero

        // 덤벨 구성
        dumbbell.addChild(leftWeight)
        dumbbell.addChild(rightWeight)
        dumbbell.addChild(handle)

        // 각 파츠별 물리 바디 생성
        let leftBody = SKPhysicsBody(rectangleOf: leftWeight.size, center: leftWeight.position)
        let rightBody = SKPhysicsBody(rectangleOf: rightWeight.size, center: rightWeight.position)
        let handleBody = SKPhysicsBody(rectangleOf: handle.size, center: handle.position)

        // 파츠를 합쳐 복합 물리 바디 생성
        let compoundBody = SKPhysicsBody(bodies: [leftBody, rightBody, handleBody])

        // 물리 속성 설정
        compoundBody.restitution = 1.0          // 튕김 정도
        compoundBody.angularVelocity = 2.0      // 초기 회전
        compoundBody.angularDamping = 0.1       // 회전 감속
        compoundBody.linearDamping = 0.3        // 이동 감속
        compoundBody.friction = 0.8             // 마찰력
        compoundBody.allowsRotation = true

        dumbbell.physicsBody = compoundBody
        addChild(dumbbell)
    }
    
    func addObstacles() {
        let obstacleSize = CGSize(width: 100, height: 20)

        // 장애물 1: 화면 위쪽
        let obstacle1 = SKSpriteNode(color: .black, size: obstacleSize)
        obstacle1.position = CGPoint(x: frame.midX, y: frame.height - 100)
        obstacle1.physicsBody = SKPhysicsBody(rectangleOf: obstacleSize)
        obstacle1.physicsBody?.isDynamic = false // 고정된 장애물
        addChild(obstacle1)

        // 장애물 2: 화면 아래쪽
        let obstacle2 = SKSpriteNode(color: .black, size: obstacleSize)
        obstacle2.position = CGPoint(x: frame.midX - 150, y: 150)
        obstacle2.physicsBody = SKPhysicsBody(rectangleOf: obstacleSize)
        obstacle2.physicsBody?.isDynamic = false
        addChild(obstacle2)

        // 장애물 3: 화면 중간 좌측
        let obstacle3 = SKSpriteNode(color: .black, size: CGSize(width: 20, height: 120))
        obstacle3.position = CGPoint(x: 100, y: frame.midY)
        obstacle3.physicsBody = SKPhysicsBody(rectangleOf: obstacle3.size)
        obstacle3.physicsBody?.isDynamic = false
        addChild(obstacle3)
    }

    // 키 입력 또는 버튼 처리에 따라 회전 방향 조정도 가능
    func rotateLeft() {
        dumbbell.physicsBody?.applyAngularImpulse(0.2)
    }

    func rotateRight() {
        dumbbell.physicsBody?.applyAngularImpulse(-0.2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let body = dumbbell.physicsBody else { return }

        let maxAngularVelocity: CGFloat = 10.0 // 최대 회전 속도 제한

        if body.angularVelocity > maxAngularVelocity {
            body.angularVelocity = maxAngularVelocity
        } else if body.angularVelocity < -maxAngularVelocity {
            body.angularVelocity = -maxAngularVelocity
        }
    }
}
