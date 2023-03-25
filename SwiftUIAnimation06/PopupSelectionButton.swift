//
//  PopupSelectionButton.swift
//  SwiftUIAnimation06
//
//  Created by gzonelee on 2023/03/25.
//

import SwiftUI

struct PopupSelectionButton: View {
    @Binding var currentValue: Double?
    var values: [Double]
    @State var showOptions = false
    @State var animateOptions = false
    var body: some View {
        ZStack {
            if showOptions {
                ForEach(values.indices, id: \.self) { index in
                    Text(values[index], format: .number)
                        .transition(.scale.animation(.easeOut(duration: 0.25)))
                        .modifier(CircledTextToggle(backgroundColor: .yellow))
                        .offset(
                            x: animateOptions ? xOffset(for: index) : 0,
                            y: animateOptions ? yOffset(for: index) : 0)
                        .onTapGesture {
                            currentValue = values[index]
                            withAnimation(.easeOut(duration: 0.25)) {
                                animateOptions = false
                            }
                            withAnimation {
                                showOptions = false
                            }
                        }
                }
                Text("\(Image(systemName: "xmark.circle"))")
                    .transition(.opacity.animation(.linear(duration: 0.25)))
                    .modifier(CircledTextToggle(backgroundColor: .red))
            }
            Group {
                if let currentValue {
                    Text(currentValue, format: .number)
                        .modifier(CircledTextToggle(backgroundColor: .green))
                }
                else {
                    Text("\(Image(systemName: "exclamationmark"))")
                        .modifier(CircledTextToggle(backgroundColor: .red))
                }
            }
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.25)) {
                    animateOptions = !showOptions
                }
                withAnimation {
                    showOptions.toggle()
                }
            }
        }
    }
    func xOffset(for index: Int) -> Double {
        let distance = 180.0
        let angle = Angle(degrees: Double(15 * index)).radians
        return distance * cos(angle) - distance
    }
    
    func yOffset(for index: Int) -> Double {
        let distance = 180.0
        let angle = Angle(degrees: Double(15 * index)).radians
        return -distance * sin(angle) - 45.0
    }
}

struct PopupSelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            PopupSelectionButton(currentValue: .constant(3), values: [1, 1.5, 2, 2.5, 3, 4, 5])
                .padding()
            PopupSelectionButton(currentValue: .constant(nil), values: [1, 1.5, 2, 2.5, 3, 4, 5])
                .padding()
        }
        .padding()
    }
}

struct CircledText: ViewModifier {
    // 1
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
        // 2
            .contentShape(Circle())
            .foregroundColor(.white)
            .font(.title2)
            .padding(5)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .aspectRatio(contentMode: .fill)
            }
    }
}

struct CircledTextToggle: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: 30, height: 30)
            .modifier(CircledText(backgroundColor: backgroundColor))
    }
}

