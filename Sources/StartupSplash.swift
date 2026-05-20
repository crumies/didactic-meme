import SwiftUI

struct StartupSplash: View {
    @EnvironmentObject var settings: AppSettings
    @State private var scale = 0.78
    @State private var glow = false
    @State private var sweep = false
    @State private var fadeText = false
    @State private var wheelSpin = false
    @State private var bikeDrive = false
    @State private var smokePulse = false

    var body: some View {
        ZStack {
            AppBackground()

            if settings.tireStartupAnimation {
                bikeRolloutIntro
            } else {
                ringIntro
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.05, dampingFraction: 0.74)) { scale = 1.0 }
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) { glow = true }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { fadeText = true }
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) { sweep = true }
            withAnimation(.linear(duration: 0.48).repeatForever(autoreverses: false)) { wheelSpin = true }
            withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) { smokePulse = true }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 1.7)) { bikeDrive = true }
            }
        }
    }

    private var ringIntro: some View {
        ZStack {
            Circle()
                .fill(.cyan.opacity(glow ? 0.30 : 0.09))
                .blur(radius: 105)
                .frame(width: glow ? 500 : 260)

            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .trim(from: 0.05, to: 0.32)
                        .stroke(.cyan.opacity(0.16), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .frame(width: CGFloat(240 + index * 70), height: CGFloat(240 + index * 70))
                        .rotationEffect(.degrees(sweep ? 360 + Double(index * 55) : Double(index * 55)))
                }

                Circle()
                    .stroke(.white.opacity(glow ? 0.10 : 0.04), lineWidth: 1)
                    .frame(width: glow ? 420 : 280)
            }

            VStack(spacing: 20) {
                AptumLogoImage()
                    .frame(width: 340, height: 122)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.58 : 0.18), radius: glow ? 36 : 12)

                Text("Connecting electric drive")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.45))
            }
        }
    }

    private var bikeRolloutIntro: some View {
        ZStack {
            Circle()
                .fill(.cyan.opacity(glow ? 0.22 : 0.07))
                .blur(radius: 110)
                .frame(width: glow ? 520 : 280)

            VStack(spacing: 24) {
                ZStack {
                    // Smoke trail in front of the glow, but behind the sketch bike.
                    ForEach(0..<8, id: \.self) { i in
                        Capsule()
                            .fill(.white.opacity(smokePulse ? 0.20 : 0.08))
                            .frame(width: CGFloat(78 + i * 18), height: CGFloat(16 + i * 3))
                            .blur(radius: CGFloat(2 + i / 2))
                            .offset(x: CGFloat(-130 - i * 18), y: CGFloat(36 - i * 7))
                            .scaleEffect(smokePulse ? 1.16 : 0.90)
                    }

                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(.cyan.opacity(smokePulse ? 0.18 : 0.06))
                            .frame(width: CGFloat(12 + i * 5), height: CGFloat(12 + i * 5))
                            .blur(radius: 2)
                            .offset(x: CGFloat(-78 - i * 30), y: CGFloat(50 - i * 8))
                    }

                    SketchEMoto(wheelSpin: wheelSpin)
                        .frame(width: 250, height: 145)
                        .offset(x: bikeDrive ? 165 : -155, y: 6)
                        .shadow(color: .cyan.opacity(0.35), radius: 18)

                    Capsule()
                        .fill(.cyan.opacity(0.20))
                        .frame(width: 260, height: 4)
                        .blur(radius: 4)
                        .offset(x: bikeDrive ? 95 : -60, y: 74)
                }
                .frame(height: 190)
                .clipped()

                AptumLogoImage()
                    .frame(width: 330, height: 112)
                    .scaleEffect(scale)
                    .shadow(color: .cyan.opacity(glow ? 0.55 : 0.15), radius: glow ? 36 : 12)

                Text("Traction systems online")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.cyan.opacity(fadeText ? 0.95 : 0.45))
            }
        }
    }
}

struct SketchEMoto: View {
    let wheelSpin: Bool

    var body: some View {
        ZStack {
            sketchLine(points: [
                CGPoint(x: 42, y: 106),
                CGPoint(x: 78, y: 60),
                CGPoint(x: 132, y: 55),
                CGPoint(x: 172, y: 86),
                CGPoint(x: 205, y: 106)
            ], width: 4)

            sketchLine(points: [
                CGPoint(x: 78, y: 60),
                CGPoint(x: 103, y: 95),
                CGPoint(x: 150, y: 95),
                CGPoint(x: 132, y: 55)
            ], width: 3)

            sketchLine(points: [
                CGPoint(x: 132, y: 55),
                CGPoint(x: 165, y: 42),
                CGPoint(x: 194, y: 47)
            ], width: 4)

            sketchLine(points: [
                CGPoint(x: 170, y: 45),
                CGPoint(x: 184, y: 30),
                CGPoint(x: 210, y: 28)
            ], width: 3)

            RoundedRectangle(cornerRadius: 10)
                .stroke(.cyan.opacity(0.85), lineWidth: 3)
                .frame(width: 68, height: 22)
                .offset(x: 12, y: -30)

            sketchWheel(x: 46)
            sketchWheel(x: 205)

            Capsule()
                .fill(.cyan.opacity(0.25))
                .frame(width: 42, height: 10)
                .offset(x: 92, y: -50)

            Circle()
                .fill(.cyan.opacity(0.9))
                .frame(width: 8, height: 8)
                .offset(x: 112, y: -54)
                .shadow(color: .cyan, radius: 10)
        }
    }

    private func sketchWheel(x: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.80), lineWidth: 6)
                .frame(width: 58, height: 58)

            Circle()
                .stroke(.cyan.opacity(0.70), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10, 7]))
                .frame(width: 58, height: 58)
                .rotationEffect(.degrees(wheelSpin ? 360 : 0))

            ForEach(0..<6, id: \.self) { i in
                Rectangle()
                    .fill(.white.opacity(0.45))
                    .frame(width: 3, height: 24)
                    .offset(y: -12)
                    .rotationEffect(.degrees(Double(i) * 60 + (wheelSpin ? 360 : 0)))
            }

            Circle()
                .fill(.black.opacity(0.65))
                .frame(width: 18, height: 18)
        }
        .offset(x: x - 125, y: 34)
    }

    private func sketchLine(points: [CGPoint], width: CGFloat) -> some View {
        Path { path in
            guard let first = points.first else { return }
            path.move(to: first)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(.white.opacity(0.88), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
        .overlay(
            Path { path in
                guard let first = points.first else { return }
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(.cyan.opacity(0.50), style: StrokeStyle(lineWidth: max(1, width - 2), lineCap: .round, lineJoin: .round))
        )
    }
}
