//
//  Home.swift
//  SwiftCharts
//
//  Created by Jiaxin Shou on 2022/6/19.
//

import Charts
import SwiftUI

struct Home: View {
    @State private var sampleAnalytics: [SiteView] = SAMPLE_ANALYTICS

    @State private var currentTab: String = "7 Days"

    @State private var currentActiveItem: SiteView?

    @State private var plotWidth: CGFloat = 0

    @State private var isLineGraph: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Views")
                            .fontWeight(.semibold)

                        Picker("", selection: $currentTab) {
                            Text("7 Days")
                                .tag("7 Days")

                            Text("Week")
                                .tag("Week")

                            Text("Month")
                                .tag("Month")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 80)
                    }

                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                        item.views + partialResult
                    }

                    Text(totalValue.stringFormat)
                        .font(.largeTitle.bold())

                    animatedChart()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }

                Toggle("Line Graph", isOn: $isLineGraph)
                    .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Swift Charts")
            .onChange(of: currentTab) { newValue in
                sampleAnalytics = SAMPLE_ANALYTICS
                if newValue != "7 Days" {
                    for (index, _) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].views = .random(in: 1500 ... 10000)
                    }
                }

                animateGraph(fromChange: true)
            }
        }
    }

    @ViewBuilder
    private func animatedChart() -> some View {
        let max = sampleAnalytics.max {
            $0.views < $1.views
        }?.views ?? 0
        Chart {
            ForEach(sampleAnalytics) { item in
                if isLineGraph {
                    LineMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color.accentColor.gradient)
                    .interpolationMethod(.catmullRom)
                } else {
                    BarMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color.accentColor.gradient)
                }

                if isLineGraph {
                    AreaMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color.accentColor.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }

                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.hour))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Views")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(currentActiveItem.views.stringFormat)
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
        }
        .chartYScale(domain: 0 ... (max + 5000))
        .chartOverlay { proxy in
            GeometryReader { _ in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    if let currentItem = sampleAnalytics.first(where: { item in
                                        calendar.component(.hour, from: item.hour) == hour
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }
                            .onEnded { _ in
                                self.currentActiveItem = nil
                            }
                    )
            }
        }
        .frame(height: 250)
        .onAppear {
            animateGraph()
        }
    }

    private func animateGraph(fromChange: Bool = false) {
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
}

private extension Double {
    var stringFormat: String {
        if self >= 10000, self < 999_999 {
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 1_000_000 {
            return String(format: "%.1fM", self / 10000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", self)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
