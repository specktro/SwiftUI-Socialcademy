//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by specktro on 11/12/24.
//

import Firebase
import SwiftUI

@main
struct SocialcademyApp: App {
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
