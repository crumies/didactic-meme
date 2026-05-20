import SwiftUI

struct ConnectionHomeView: View {
    @EnvironmentObject var ble: DunenBLEManager

    var body: some View {
        ZStack {
            AptumMeaningBackground()

            VStack(spacing: 20) {
                HStack {
                    AptumLogoImage()
                        .frame(width: 170, height: 56)
                    Spacer()
                    Button("Demo") {
                        ble.setDemoMode(true)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                }

                Spacer(minLength: 8)

                GlassCard(glow: true) {
                    VStack(spacing: 18) {
                        AptumBikeImage()
                            .frame(height: 190)

                        Text("Connect Vehicle")
                            .font(.largeTitle.weight(.heavy))

                        Text(ble.connectionStatus)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button(ble.isScanning ? "Scanning..." : "Scan for Devices") {
                            ble.startScan()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.cyan)
                        .disabled(ble.isScanning)
                    }
                }

                if !ble.discoveredDevices.isEmpty {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nearby Devices").font(.headline)
                            ForEach(ble.discoveredDevices) { device in
                                Button { ble.connect(to: device) } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(device.name).fontWeight(.semibold)
                                            Text(device.id.uuidString).font(.caption2).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text("\(device.rssi) dBm").font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                                Divider().opacity(0.2)
                            }
                        }
                    }
                }

                if !ble.savedDevices.isEmpty {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Remembered Devices").font(.headline)
                            ForEach(ble.savedDevices.prefix(4)) { device in
                                HStack {
                                    Text(device.name)
                                    Spacer()
                                    Text("seen").font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
        }
    }
}

struct AptumMeaningBackground: View {
    private let words = [
        "ALWAYS",
        "PROGRESSING",
        "TOWARD",
        "ULTIMATE",
        "MOBILITY"
    ]

    // Safe positions: all centered enough so no word gets cut off left/right/bottom.
    private let positions: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.12),
        CGPoint(x: 0.50, y: 0.21),
        CGPoint(x: 0.50, y: 0.70),
        CGPoint(x: 0.50, y: 0.79),
        CGPoint(x: 0.50, y: 0.88)
    ]

    private let sizes: [CGFloat] = [25, 34, 23, 29, 27]

    var body: some View {
        GeometryReader { geo in
            TimelineView(.periodic(from: .now, by: 0.05)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    ForEach(words.indices, id: \.self) { index in
                        // Faster than before, but still smooth.
                        let phase = t * 0.72 + Double(index) * 0.72
                        let wave = (sin(phase) + 1) / 2
                        let opacity = smoothFade(wave) * 0.23
                        let drift = CGFloat(sin(phase * 0.65)) * 4

                        Text(words[index])
                            .font(.system(size: sizes[index], weight: .black, design: .rounded))
                            .tracking(2.1)
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)
                            .foregroundStyle(.cyan.opacity(opacity))
                            .scaleEffect(0.97 + wave * 0.035)
                            .position(
                                x: min(max(geo.size.width * positions[index].x + drift, 80), geo.size.width - 80),
                                y: min(max(geo.size.height * positions[index].y, 46), geo.size.height - 54)
                            )
                            .allowsHitTesting(false)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func smoothFade(_ value: Double) -> Double {
        if value < 0.12 { return 0 }
        let x = min(max((value - 0.12) / 0.88, 0), 1)
        return x * x * (3 - 2 * x)
    }
}