//
//  Enum.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 26.04.2023.
//

import Foundation

enum AuthError : Error{
    case userNotExist
}

enum MyError : Error{
    case invalidData
    case unexpectedResult(description : String)
}

enum AppError: Error {
    case registrationFailed
    case dataSaveFailed
    //...
}
