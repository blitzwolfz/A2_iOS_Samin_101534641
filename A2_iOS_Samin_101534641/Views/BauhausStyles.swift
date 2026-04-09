import SwiftUI

struct BauhausTheme {
    static let red = Color(red: 0.898, green: 0.224, blue: 0.208)
    static let blue = Color(red: 0.082, green: 0.396, blue: 0.753)
    static let yellow = Color(red: 0.992, green: 0.847, blue: 0.208)
    static let black = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let white = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let gray = Color(red: 0.92, green: 0.92, blue: 0.92)
}

struct BauhausCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(BauhausTheme.white)
            .overlay(
                Rectangle()
                    .stroke(BauhausTheme.black, lineWidth: 3)
            )
    }
}

struct BauhausPrimaryButton: ViewModifier {
    var color: Color = BauhausTheme.red

    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold, design: .default))
            .foregroundColor(BauhausTheme.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(color)
            .overlay(
                Rectangle()
                    .stroke(BauhausTheme.black, lineWidth: 2)
            )
    }
}

struct BauhausTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .stroke(BauhausTheme.black, lineWidth: 2)
            )
            .font(.system(size: 16, weight: .regular, design: .monospaced))
    }
}

struct GeometricAccent: View {
    var colors: [Color] = [BauhausTheme.red, BauhausTheme.blue, BauhausTheme.yellow]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(colors.indices, id: \.self) { index in
                Rectangle()
                    .fill(colors[index])
                    .frame(height: 6)
            }
        }
    }
}

struct BauhausHeader: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            GeometricAccent()

            HStack {
                Rectangle()
                    .fill(BauhausTheme.red)
                    .frame(width: 8)

                Text(title.uppercased())
                    .font(.system(size: 28, weight: .black, design: .default))
                    .foregroundColor(BauhausTheme.black)
                    .kerning(3)

                Spacer()
            }
            .frame(height: 56)
            .background(BauhausTheme.white)

            GeometricAccent(colors: [BauhausTheme.black, BauhausTheme.black, BauhausTheme.black])
                .frame(height: 3)
        }
    }
}

extension View {
    func bauhausCard() -> some View {
        modifier(BauhausCard())
    }

    func bauhausPrimaryButton(color: Color = BauhausTheme.red) -> some View {
        modifier(BauhausPrimaryButton(color: color))
    }

    func bauhausTextField() -> some View {
        modifier(BauhausTextField())
    }
}
