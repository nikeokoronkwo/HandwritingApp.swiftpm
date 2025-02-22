//
//  Errors.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

public enum AssetError: Error {
    case notFound
    case invalid(String)
    case bad(String)
    case unknown
    case custom(Error)
}

public enum ImageError: Error {
    case invalidInput
    case unknown
    case bad(String)
}
