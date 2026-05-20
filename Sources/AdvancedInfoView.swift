import SwiftUI

struct AdvancedInfoView: View {
    @EnvironmentObject var ble: DunenBLEManager

    private var estimatedWhPerKm: Double {
        let speed = max(ble.telemetry.speedKmh, 1.0)
        let powerW = max(ble.telemetry.powerKw * 1000.0, 0.0)

        // More realistic fallback for a 72V 38.4Ah e-moto:
        // Low speed/cruise usually around 35-45 Wh/km, faster riding more like 55-80 Wh/km.
        let live = speed > 8 && powerW > 250 ? powerW / speed : 42.0
        let speedAdjusted = 34.0 + (speed * 0.38)

        // Blend live + speed estimate so idle/demo does not become crazy.
        return min(max((live * 0.45) + (speedAdjusted * 0.55), 32.0), 85.0)
    }

    private var estimatedRangeKm: Double {
        // 72V * 38.4Ah ≈ 2765Wh. Use 82% usable to stay realistic.
        let usableWh = 72.0 * 38.4 * 0.82
        let remainingWh = usableWh * max(0.0, min(100.0, ble.telemetry.batteryPercent)) / 100.0
        return min(max(remainingWh / max(estimatedWhPerKm, 1.0), 0), 82)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                title("Advanced Info", "Live calculated controller data")

                GlassCard(glow: true) {
                    VStack(spacing: 12) {
                        row("RPM", "\(ble.telemetry.rpm)")
                        row("Voltage", String(format: "%.1f V", ble.telemetry.voltage))
                        row("Current", String(format: "%.1f A", ble.telemetry.currentA))
                        row("Power", String(format: "%.1f kW", ble.telemetry.powerKw))
                        row("WarningCode", "\(ble.telemetry.warningCode)")
                        row("ErrCode", "\(ble.telemetry.errorCode)")
                    }
                }

                GlassCard {
                    VStack(spacing: 12) {
                        row("Lean Estimate", String(format: "%.1f°", ble.telemetry.leanAngle))
                        row("G-Force Estimate", String(format: "%.2f g", ble.telemetry.gForce))
                        row("Wheel RPM", String(format: "%.0f rpm", ble.telemetry.wheelRPM))
                        row("Wheel Torque Est.", String(format: "%.1f Nm", ble.telemetry.wheelTorqueNm))
                        row("Theoretical Top", String(format: "%.0f km/h", ble.telemetry.theoreticalTopSpeedKmh))
                    }
                }

                GlassCard {
                    VStack(spacing: 12) {
                        row("Battery % Est.", String(format: "%.0f %%", ble.telemetry.batteryPercent))
                        row("Voltage Sag", String(format: "%.2f V", ble.telemetry.voltageSag))
                        row("Motor Temp", String(format: "%.1f °C", ble.telemetry.motorTemp))
                        row("Controller Temp", String(format: "%.1f °C", ble.telemetry.controllerTemp))
                        row("Wh/km Est.", String(format: "%.1f Wh/km", estimatedWhPerKm))
                        row("Range Est.", String(format: "%.0f km", estimatedRangeKm))
                        heatBar(value: ble.telemetry.controllerTemp)
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Chain Drive Setup")
                            .font(.headline)
                        row("Battery", "72V 38.4Ah")
                        row("Motor", "4000W / 8000W peak")
                        row("Rear sprocket", "48T")
                        row("Rear wheel", "18 inch")
                        row("Front wheel", "19 inch")
                        row("Drive", "Chain")
                        Text("Wheel torque and top speed are estimates from speed/RPM and assumed gearing.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 82)
        }
    }

    private func title(_ a: String, _ b: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(a).font(.largeTitle.weight(.heavy))
                Text(b).font(.caption).foregroundStyle(.cyan)
            }
            Spacer()
            ConnectionPill()
        }
    }

    private func row(_ name: String, _ value: String) -> some View {
        HStack {
            Text(name).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold)
        }
    }

    private func heatBar(value: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value < 55 ? "Safe" : (value < 75 ? "Warm" : "Hot / Power Reduced"))
                .font(.caption.weight(.bold))
                .foregroundStyle(value < 55 ? .green : (value < 75 ? .orange : .red))
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.12))
                    Capsule()
                        .fill(value < 55 ? .green : (value < 75 ? .orange : .red))
                        .frame(width: geo.size.width * min(value / 100.0, 1.0))
                }
            }
            .frame(height: 10)
        }
    }
}
