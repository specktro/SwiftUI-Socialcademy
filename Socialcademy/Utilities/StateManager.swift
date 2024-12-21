//
//  StateManager.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }
}

extension StateManager {
    typealias Action = () async throws -> Void

    var isWorking: Bool {
        get { false }
        set {}
    }
    
    nonisolated func withStateManagingTask(perform action: @escaping () async throws -> Void) {
        Task {
            await withStateManagement(perform: action)
        }
    }
    
    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
     
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        
        isWorking = false
    }
}
