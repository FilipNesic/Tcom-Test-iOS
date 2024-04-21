//
//  LoginModel.swift
//  TaskApp
//
//  Created by Filip Nesic on 19.4.24..
//

import Foundation

struct LoginResponse: Decodable {
    let user: User
    let token: String
}

struct User: Decodable {
    let id: Int
    let email: String
}
