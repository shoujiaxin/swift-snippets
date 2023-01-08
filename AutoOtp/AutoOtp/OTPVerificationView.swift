//
//  OTPVerificationView.swift
//  AutoOtp
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct OTPVerificationView: View {
    @State
    private var otpText: String = ""

    @FocusState
    private var isKeyboardShowing: Bool

    var body: some View {
        VStack {
            Text("Verify OTP")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                ForEach(0 ..< 6, id: \.self) { index in
                    otpTextBox(index)
                }
            }
            .background {
                TextField("", text: $otpText.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing.toggle()
            }
            .padding(.bottom, 20)
            .padding(.top, 10)

            Button {} label: {
                Text("Verify")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.blue)
                    }
            }
            .disableWithOpacity(otpText.count < 6)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func otpTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            let status = isKeyboardShowing && otpText.count == index
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .black : .gray, lineWidth: status ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.2), value: status)
        }
        .frame(maxWidth: .infinity)
    }
}

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if wrappedValue.count > length {
            DispatchQueue.main.async {
                wrappedValue = String(wrappedValue.prefix(length))
            }
        }
        return self
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView()
    }
}
