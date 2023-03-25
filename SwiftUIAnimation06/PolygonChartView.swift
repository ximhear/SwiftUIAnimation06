//
//  PolygonChartView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/25.
//

import SwiftUI

struct PolygonChartView: View {
    var values: [Double]
    var graphSize: Double
    var colorArray: [Color]
    var xCenter: Double
    var yCenter: Double
    
    var gradientColors: AngularGradient {
        AngularGradient(colors: colorArray + [colorArray.first ?? .blue],
                        center: .center,
                        angle: .degrees(0)
        )
    }
    
    var body: some View {
        Path { path in
            for index in values.indices {
                let v = values[index]
                let radians = Angle(degrees: 72.0 * Double(index)).radians
                let x = cos(radians) * graphSize * v
                let y = sin(radians) * graphSize * v
                if index == 0 {
                    path.move(to: .init(x: x, y: y))
                }
                else {
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
        .offset(x: xCenter, y: yCenter)
        .fill(gradientColors)
        .opacity(0.5)
    }
}

struct PolygonChartView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            PolygonChartView(values: [0.6, 0.5, 0.7, 0.8, 0.7],
                             graphSize: proxy.size.width / 2.0,
                             colorArray: [.black, .red, .blue, .green, .yellow],
                             xCenter: proxy.size.width / 2.0,
                             yCenter: proxy.size.height / 2.0
            )
        }
    }
}
