//
//  ContentView.swift
//  InteractiveCharts
//
//  Created by Jiaxin Shou on 2023/7/3.
//

import Charts
import SwiftUI

struct ContentView: View {
    @State
    private var graphType: GraphType = .bar

    @State
    private var barSelection: String? = nil

    @State
    private var pieSelection: Double? = nil

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $graphType) {
                    ForEach(GraphType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)

                ZStack {
                    if let maxValue = sampleData.max(by: { $0.count < $1.count }) {
                        if graphType == .bar {
                            chartPopover(count: maxValue.count, month: maxValue.month, isHeaderView: true)
                                .opacity(barSelection == nil ? 1 : 0)
                        } else if let barSelection, let selectedData = sampleData.findData(by: barSelection) {
                            chartPopover(count: selectedData, month: barSelection, isHeaderView: true, isSelection: true)
                        } else {
                            chartPopover(count: maxValue.count, month: maxValue.month, isHeaderView: true)
                        }
                    }
                }
                .padding(.vertical)

                Chart {
                    ForEach(sampleData.sorted(by: { graphType == .bar ? false : $0.count > $1.count })) {
                        switch graphType {
                        case .bar:
                            barChart($0)
                        case .pie, .donut:
                            pieAndDonutChart($0)
                        }
                    }

                    if let barSelection {
                        RuleMark(x: .value("Month", barSelection))
                            .foregroundStyle(.gray.opacity(0.35))
                            .zIndex(-1)
                            .offset(yStart: -10)
                            .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                                if let data = sampleData.findData(by: barSelection) {
                                    chartPopover(count: data, month: barSelection)
                                }
                            }
                    }
                }
                .chartXSelection(value: $barSelection)
                .chartAngleSelection(value: $pieSelection)
                .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .animation(graphType == .bar ? nil : .snappy, value: graphType)

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Interactive Chart")
            .onChange(of: pieSelection, initial: false) { _, newValue in
                if let newValue {
                    selectData(with: newValue)
                } else {
                    barSelection = nil
                }
            }
        }
    }

    private func barChart(_ data: AppDownload) -> some ChartContent {
        BarMark(
            x: .value("Month", data.month),
            y: .value("Downloads", data.count)
        )
        .cornerRadius(8)
        .foregroundStyle(by: .value("Month", data.month))
    }

    private func pieAndDonutChart(_ data: AppDownload) -> some ChartContent {
        SectorMark(
            angle: .value("Downloads", data.count),
            innerRadius: .ratio(graphType == .donut ? 0.5 : 0),
            angularInset: graphType == .donut ? 6 : 1
        )
        .cornerRadius(8)
        .foregroundStyle(by: .value("Month", data.month))
        .opacity(barSelection == nil ? 1 : (barSelection == data.month ? 1 : 0.4))
    }

    private func chartPopover(count: Double,
                              month: String,
                              isHeaderView: Bool = false,
                              isSelection: Bool = false) -> some View
    {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(isHeaderView && !isSelection ? "Max" : "App") Downloads")
                .foregroundStyle(.gray)

            HStack(spacing: 4) {
                Text(String(format: "%0.f", count))
                    .fontWeight(.semibold)

                Text(month)
                    .textScale(.secondary)
            }
        }
        .font(.title3)
        .padding(isHeaderView ? .horizontal : .all)
        .background(Color(uiColor: .systemGroupedBackground).opacity(isHeaderView ? 0 : 1), in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isHeaderView ? .leading : .center)
    }

    private func selectData(with count: Double) {
        var lowerBound: Double = 0
        let convertedArray = sampleData
            .sorted(by: { graphType == .bar ? false : $0.count > $1.count })
            .compactMap { data -> (String, Range<Double>) in
                let upperBound = lowerBound + data.count
                let result = (data.month, lowerBound ..< upperBound)
                lowerBound = upperBound
                return result
            }

        if let data = convertedArray.first(where: { $0.1.contains(count) }) {
            barSelection = data.0
        }
    }
}

#Preview {
    ContentView()
}
