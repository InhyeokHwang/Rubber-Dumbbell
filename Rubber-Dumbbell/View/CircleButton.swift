import SwiftUI


struct CircleButton: View {
    let label: String
    let isActive: Bool

    var body: some View {
        Text(label)
            .font(.title)
            .foregroundColor(.black)
            .padding()
            .background(isActive ? Color.yellow.opacity(0.8) : Color.white.opacity(0.8))
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}
