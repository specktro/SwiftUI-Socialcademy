//
//  FormState.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

enum FormState {
    case idle, working, error
    
    var isError: Bool {
        get {
            self == .error
        }
        set {
            guard !newValue else {
                return
            }
            
            self = .idle
        }
    }
}
