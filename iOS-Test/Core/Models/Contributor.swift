//
//  Contributor.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 07.02.2022.
//

import Foundation

struct Contributor {
    let id: Int
    let login: String
    let avatarURLString: String?

    var avatarURL: URL? {
        if let avatarURLString = avatarURLString {
            return URL(string: avatarURLString)
        } else {
            return nil
        }
    }
}
