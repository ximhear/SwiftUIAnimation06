//
//  ContentView.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/19.
//

import SwiftUI

struct ContentView: View {
    @State var temperature: Int = 0
    var body: some View {
        VStack {
            NumberTransitionView(number: temperature, suffix: " °C")
                .font(.title)
                .bold()
            TimerView()
        }
        .padding()
        .onAppear {
            withAnimation {
                temperature = 85
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
