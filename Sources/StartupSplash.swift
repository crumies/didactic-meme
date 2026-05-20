import SwiftUI

struct StartupSplash: View {
    @State private var scale = 0.82
    @State private var glow = false
    @State private var sweep = false
    @State private var fadeText = false

    var body: some View {
        ZStack {
            AppBackground()

            Circle()
                .fill(.cyan.opacity(glow ? 0.26 : 0.08))
                .blur(radius: 120)
                .frame(width: glow ? 560 : 300)
                .drawingGroup()

            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .trim(from: 0.04, to: 0.28)
                        .stroke(.cyan.opacity(0.12), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                        .frame(width: CGFloat(235 + index * 62), height: CGFloat(235 + index * 62))
                        .rotationEffect(.degrees(sweep ? 360 + Double(index * 46) : Double(index * 46)))
                }

                Circle()
                    .stroke(.white.opacity(glow ? 0.10 : 0.04), lineWidth: 1)
                    .frame(width: glow ? 430 : 285)
            }
            .drawingGroup()

            VStack(spacing: 20) {
                AptumLogoImage()
                    .frame(width: 360, height: 125)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.52 : 0.16), radius: glow ? 34 : 10)

                Text("Connecting electric drive")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.45))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.05, dampingFraction: 0.76)) { scale = 1.0 }
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) { glow = true }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { fadeText = true }
            withAnimation(.linear(duration: 2.7).repeatForever(autoreverses: false)) { sweep = true }
        }
    }
}
