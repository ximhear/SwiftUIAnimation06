//
//  TimerDigitsView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct TimerDigitsView: View {
    var digits: [Int]
    var rawDigits: [Int]
    
    var hasMintues: Bool {
        digits[0] != 0 || digits[1] != 0
    }
    var body: some View {
        HStack {
            if hasMintues {
                if digits[0] != 0 {
                    SlidingNumber(number: Double(digits[0]), rawNumber: Double(rawDigits[0]))
                }
                SlidingNumber(number: Double(digits[1]), rawNumber: Double(rawDigits[1]))
                Text("m")
            }
            if hasMintues || digits[2] != 0 {
                SlidingNumber(number: Double(digits[2]), rawNumber: Double(rawDigits[2]))
            }
            SlidingNumber(number: Double(digits[3]), rawNumber: Double(rawDigits[3]))
            Text("s")
        }
    }
}

struct TimerDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDigitsView(digits: [1, 2, 3, 4], rawDigits: [1, 2, 3, 4])
    }
}
