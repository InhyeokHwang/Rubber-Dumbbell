import SwiftUI

struct GameWorldSpec {
    var backgroundColorHex: UInt32 = 0xFFFFFF
    var dumbbell: DumbbellSpec
    var obstacles: [ObstacleSpec]
    var limits: PhysicsLimits = .init()
}
