//
//  SlidingNumber.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct SlidingNumber: View, Animatable {
    var number: Double
    var rawNumber: Double
    var animatableData: Double {
        get {
            number
        }
        set {
            number = newValue
        }
    }
    
    var body: some View {
        let digitArray = [rawNumber + 1, rawNumber, rawNumber - 1]
            .map { $0.between(0, and: 10)
            }
        let shift: Double = abs((number - rawNumber) / Double(digitArray[1] - digitArray[0]))
            VStack {
                Text(String(digitArray[0]))
                Text(String(digitArray[1]))
                Text(String(digitArray[2]))
            }
            .font(.largeTitle)
            .fontWeight(.heavy)
            .frame(width: 30, height: 40)
            .offset(y: 40 * shift)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct SlidingNumber_Previews: PreviewProvider {
    static var previews: some View {
        SlidingNumber(number: 9, rawNumber: 9)
    }
}
extension Double {
  func between(_ low: Int, and high: Int) -> Int {
    let range = Double(high - low)
    var value = self
    while value < Double(low) {
      value += range
    }
    while value >= Double(high) {
      value -= range
    }
    return Int(value)
  }
}
extension Int {
  func between(_ low: Int, and high: Int) -> Int {
    let range = high - low
    var value = self
    while value < low {
      value += range
    }
    while value >= high {
      value -= range
    }
    return value
  }
}
