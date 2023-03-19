//
//  NumberTransitionView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct NumberTransitionView: View, Animatable {
    var number: Int
    var suffix: String
    
    var animatableData: Double {
        get {
            Double(number)
        }
        set {
            number = Int(newValue)
        }
    }
    var body: some View {
        Text("\(number) \(suffix)")
    }
}

struct NumberTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        NumberTransitionView(number: 5, suffix: " °F")
    }
}
