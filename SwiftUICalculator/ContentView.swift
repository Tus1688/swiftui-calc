//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by MacBook Pro on 29/09/23.
//

import SwiftUI

enum ButtonOption: String {
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    
    var color: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(.orange)
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State var value = "0"
    @State var currentNumber: Double = 0
    @State var currentOperation: Operation = .none
    
    let buttons: [[ButtonOption]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Value
                HStack {
                    Spacer()
                    Text(value)
                        .font(.system(size: fontSizeForValue()))
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                var selfMutating = self
                                selfMutating.onClick(button: item)
                            }, label: {
                                if item == .clear {
                                    // Check if currentNumber is not equal to 0, and set the label accordingly
                                    Text(currentNumber != 0 ? "C" : item.rawValue)
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: self.buttonHeight()
                                        )
                                        .background(item.color)
                                        .cornerRadius(self.buttonWidth(item: item)/2)
                                } else {
                                    Text(item.rawValue)
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: self.buttonHeight()
                                        )
                                        .background(item.color)
                                        .cornerRadius(self.buttonWidth(item: item)/2)
                                }
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    mutating func onClick(button: ButtonOption) {
        switch button {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            // Handle number buttons
            if value == "0" {
                value = button.rawValue
            } else {
                value += button.rawValue
            }
        case .decimal:
            // Handle decimal button
            if !value.contains(".") {
                value += button.rawValue
            }
        case .add, .subtract, .multiply, .divide:
            // Handle operator buttons
            if let currentValue = Double(value) {
                currentNumber = currentValue
                value = "0"
                switch button {
                case .add:
                    currentOperation = .add
                case .subtract:
                    currentOperation = .subtract
                case .multiply:
                    currentOperation = .multiply
                case .divide:
                    currentOperation = .divide
                default:
                    break
                }
            }
        case .equal:
            // Handle equal button
            if let currentValue = Double(value) {
                switch currentOperation {
                case .add:
                    value = "\(currentNumber + currentValue)"
                case .subtract:
                    value = "\(currentNumber - currentValue)"
                case .multiply:
                    value = "\(currentNumber * currentValue)"
                case .divide:
                    if currentValue != 0 {
                        value = "\(currentNumber / currentValue)"
                    } else {
                        value = "Error"
                    }
                case .none:
                    break
                }
                currentOperation = .none
                
                // Check if the result is a whole number and remove decimal places if it is
                if value.hasSuffix(".0") {
                    value = String(Int(Double(value)!))
                }
            }
        case .clear:
            // Handle clear button
            if value != "0" {
                // Clear the currently typed number
                value = "0"
            } else if currentNumber != 0 {
                // Clear all values when "AC" is pressed
                value = "0"
                currentNumber = 0
                currentOperation = .none
            }
        case .negative:
            // Handle negation button
            if let currentValue = Double(value) {
                let negatedValue = currentValue * -1
                value = "\(negatedValue)"
                
                // Check if the result is a whole number and remove decimal places if it is
                if value.hasSuffix(".0") {
                    value = String(Int(negatedValue))
                }
            }
        case .percent:
            // Handle percent button
            if let currentValue = Double(value) {
                value = "\(currentValue / 100)"
                
                // Check if the result is a whole number and remove decimal places if it is
                if value.hasSuffix(".0") {
                    value = String(Int(Double(value)!))
                }
            }
        }
    }
    
    // Determine the font size based on the length of the value.
    private func fontSizeForValue() -> CGFloat {
        let valueLength = CGFloat(value.count)
        let maxSize: CGFloat = 100
        let minSize: CGFloat = 32
        let step: CGFloat = 5
        
        // Gradually decrease font size as the number grows.
        let fontSize = maxSize - (valueLength * step)
        
        // Ensure font size doesn't go below the minimum size.
        return max(fontSize, minSize)
    }
    
    private func buttonWidth(item: ButtonOption) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

#Preview {
    ContentView()
}
