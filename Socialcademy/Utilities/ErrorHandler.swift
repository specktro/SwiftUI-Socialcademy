//
//  ErrorHandler.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

@MainActor
protocol ErrorHandler: AnyObject {
    var error: Error? { get set }
}

extension ErrorHandler {
    func withErrorHandlingTask(perform action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                print("[\(Self.self)] Error: \(error)")
                self.error = error
            }
        }
    }
}
