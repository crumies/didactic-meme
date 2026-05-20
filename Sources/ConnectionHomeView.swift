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

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.12)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(words.indices, id: \.self) { index in
                    let local = (sin(t * 0.9 + Double(index) * 1.25) + 1) / 2
                    let opacity = 0.05 + local * 0.19
                    Text(words[index])
                        .font(.system(size: index == 1 ? 38 : 32, weight: .black, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(.cyan.opacity(opacity))
                        .blur(radius: local < 0.20 ? 1.8 : 0.4)
                        .scaleEffect(0.96 + local * 0.08)
                        .offset(
                            x: index % 2 == 0 ? -34 : 34,
                            y: yOffset(for: index)
                        )
                        .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func yOffset(for index: Int) -> CGFloat {
        switch index {
        case 0: return -290
        case 1: return -210
        case 2: return 285
        case 3: return 355
        default: return 430
        }
    }
}
