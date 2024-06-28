//
//  TimePicker.swift
//  CustomTimePicker
//
//  Created by Coby Kim on 6/28/24.
//

import SwiftUI

struct TimePicker: View {
    
    var style: AnyShapeStyle = .init(.bar)
    
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        HStack(spacing: 0) {
            CustomView("hours", range: 0...24, self.$hours)
            CustomView("mins", range: 0...24, self.$hours)
            CustomView("secs", range: 0...24, self.$hours)
        }
        .offset(x: -25)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(self.style)
                .frame(height: 35)
        }
    }
    
    @ViewBuilder
    private func CustomView(_ title: String, range: ClosedRange<Int>,
                            _ selection: Binding<Int>) -> some View {
        PickerViewWithoutIndicator(selection: selection) {
            ForEach(range, id: \.self) { value in
                Text("\(value)")
                    .frame(width: 35, alignment: .trailing)
                    .tag(value)
            }
        }
        .overlay {
            Text(title)
                .font(.callout)
                .frame(width: 50, alignment: .leading)
                .lineLimit(1)
                .offset(x: 50)
        }
    }
}

#Preview {
    ContentView()
}

/// Helpers
struct PickerViewWithoutIndicator<Content: View, Selection: Hashable>: View {
    
    @Binding var selection: Selection
    @ViewBuilder var content: Content
    @State private var isHidden: Bool = false
    
    var body: some View {
        Picker("", selection: self.$selection) {
            if !self.isHidden {
                RemovePickerIndicator {
                    self.isHidden = true
                }
            } else {
                self.content
            }
        }
        .pickerStyle(.wheel)
    }
}

fileprivate
struct RemovePickerIndicator: UIViewRepresentable {
    
    var result: () -> ()
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let pickerView = view.pickerView {
                if pickerView.subviews.count >= 2 {
                    pickerView.subviews[1].backgroundColor = .clear
                }
                
                self.result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

fileprivate
extension UIView {
    var pickerView: UIPickerView? {
        if let view = superview as? UIPickerView {
            return view
        }
        
        return superview?.pickerView
    }
}
