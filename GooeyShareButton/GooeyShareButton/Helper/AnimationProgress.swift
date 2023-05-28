//
//  AnimationProgress.swift
//  GooeyShareButton
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import SwiftUI

extension View {
    func animationProgress<Value: VectorArithmetic>(endValue: Value, progress: @escaping (Value) -> Void) -> some View {
        modifier(AnimationProgress(endValue: endValue, onChange: progress))
    }
}

struct AnimationProgress<Value>: ViewModifier, Animatable where Value: VectorArithmetic {
    var animatableData: Value {
        didSet {
            sendProgress()
        }
    }

    let endValue: Value

    let onChange: (Value) -> Void

    init(endValue: Value, onChange: @escaping (Value) -> Void) {
        animatableData = endValue
        self.endValue = endValue
        self.onChange = onChange
    }

    func body(content: Content) -> some View {
        content
    }

    private func sendProgress() {
        DispatchQueue.main.async {
            self.onChange(animatableData)
        }
    }
}
