//
//  AnimatedRadarChart.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/25.
//

import SwiftUI

struct AnimatedRadarChart: View, Animatable {
    var time: Double
    var temperature: Double
    var amountWater: Double
    var amountTea: Double
    var rating: Double
    var animatableData: AnimatablePair<
    AnimatablePair<Double, Double>,
    AnimatablePair<AnimatablePair<Double, Double>, Double>> {
        get {
            AnimatablePair(AnimatablePair(time, temperature), AnimatablePair(AnimatablePair(amountWater, amountTea), rating))
            
        }
        set {
            time = newValue.first.first
            temperature = newValue.first.second
            amountWater = newValue.second.first.first
            amountTea = newValue.second.first.second
            rating = newValue.second.second
        }
    }
    
    var values: [Double] {
        [
            time / 120.0,
            temperature / 100.0,
            amountWater / 200,
            amountTea / 100,
            rating / 5.0
        ]
    }
    
    let lineColors: [Color] = [
        .black,
        .red,
        .blue,
        .green,
        .yellow
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let graphSize = min(proxy.size.width, proxy.size.height) / 2.0
                let xCenter = proxy.size.width / 2.0
                let yCenter = proxy.size.height / 2.0
                let chartFraction = Array(stride(from: 0.2, to: 1.1, by: 0.2))
                ForEach(chartFraction, id: \.self) { f in
                    Path { path in
                        path.addArc(center: .zero, radius: graphSize * f,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360),
                                    clockwise: true)
                    }
                    .stroke(.gray, lineWidth: 0.5)
                    .offset(x: xCenter, y: yCenter)
                    
                }
                ForEach(0..<5, id: \.self) { index in
                    Path { path in
                        path.move(to: .zero)
                        path.addLine(to: .init(x: 0, y: -graphSize))
                    }
                    .stroke(.gray, lineWidth: 0.5)
                    .offset(x: xCenter, y: yCenter)
                    .rotationEffect(.degrees(72.0 * Double(index)))
                    Path { path in
                        path.move(to: .zero)
                        path.addLine(to: .init(x: 0, y: -graphSize * values[index]))
                    }
                    .stroke(lineColors[index], lineWidth: 2)
                    .offset(x: xCenter, y: yCenter)
                    .rotationEffect(.degrees(72.0 * Double(index)))
                }
                PolygonChartView(values: values,
                                 graphSize: graphSize,
                                 colorArray: lineColors,
                                 xCenter: xCenter,
                                 yCenter: yCenter)
                .rotationEffect(.degrees(-90))
            }
        }
    }
}

struct AnimatedRadarChart_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedRadarChart(
            time: 30,
            temperature: 78,
            amountWater: 120,
            amountTea: 30,
            rating: 3.75
        )
    }
}
