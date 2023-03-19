//
//  SlidingNumber.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct SlidingNumber: View, Animatable {
    var number: Double
    var animatableData: Double {
        get {
            number
        }
        set {
            number = newValue
        }
    }
    
    var body: some View {
        let digitArray = [number + 1, number, number - 1]
            .map { Int($0).between(0, and: 10)
            }
        let shift = number.truncatingRemainder(dividingBy: 1)
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
        SlidingNumber(number: 0)
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
