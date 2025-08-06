import SwiftUI

struct DumbbellSpec {
    var leftSize: CGSize = .init(width: 40, height: 80)
    var rightSize: CGSize = .init(width: 40, height: 80)
    var handleSize: CGSize = .init(width: 100, height: 20)
    var restitution: CGFloat = 1.0
    var angularDamping: CGFloat = 0.1
    var linearDamping: CGFloat = 0.3
    var friction: CGFloat = 0.8
    var initialAngularVelocity: CGFloat = 2.0
    var startPosition: CGPoint = .zero 
}
