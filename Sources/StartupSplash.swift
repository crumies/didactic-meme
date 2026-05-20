import SwiftUI

struct StartupSplash: View {
    @State private var scale = 0.82
    @State private var glow = false
    @State private var fadeText = false

    var body: some View {
        ZStack {
            AppBackground()

            Circle()
                .fill(.cyan.opacity(glow ? 0.25 : 0.08))
                .blur(radius: 125)
                .frame(width: glow ? 560 : 300)
                .drawingGroup()

            ZStack {
                Circle()
                    .stroke(.cyan.opacity(glow ? 0.16 : 0.07), lineWidth: 1.4)
                    .frame(width: glow ? 425 : 295)

                Circle()
                    .stroke(.white.opacity(glow ? 0.09 : 0.035), lineWidth: 1)
                    .frame(width: glow ? 350 : 260)

                Circle()
                    .fill(.cyan.opacity(glow ? 0.08 : 0.03))
                    .frame(width: glow ? 230 : 180)
                    .blur(radius: 28)
            }
            .drawingGroup()

            VStack(spacing: 14) {
                AptumLogoImage()
                    .frame(width: 360, height: 125)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.52 : 0.16), radius: glow ? 34 : 10)

                Text("Always Progressing Toward Ultimate Mobility")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .tracking(1.4)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.42))
                    .shadow(color: .cyan.opacity(glow ? 0.26 : 0.08), radius: 12)
                    .padding(.horizontal, 24)

                Text("Connecting electric drive")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary.opacity(fadeText ? 0.95 : 0.45))
                    .padding(.top, 4)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.05, dampingFraction: 0.76)) { scale = 1.0 }
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) { glow = true }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { fadeText = true }
        }
    }
}
