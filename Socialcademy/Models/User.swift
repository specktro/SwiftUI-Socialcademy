//
//  User.swift
//  Socialcademy
//
//  Created by specktro on 16/12/24.
//

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
