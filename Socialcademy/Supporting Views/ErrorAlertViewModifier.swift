//
//  ErrorAlertViewModifier.swift
//  Socialcademy
//
//  Created by specktro on 15/12/24.
//

import SwiftUI

private struct ErrorAlertViewModifier: ViewModifier {
    let title: String
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $error.hashValue, presenting: error, actions: { _ in }) { error in
                Text(error.localizedDescription)
            }
    }
}

private extension Optional {
    var hashValue: Bool {
        get {
            self != nil
        }
        set {
            self = newValue ? self : nil
        }
    }
}

extension View {
    func alert(_ title: String, error: Binding<Error?>) -> some View {
        modifier(ErrorAlertViewModifier(title: title, error: error))
    }
}
