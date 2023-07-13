//
//  ErrorMessage.swift
//  GitHubFollowers
//
//  Created by Alex on 27.02.2022.
//

import Foundation

enum GFError: String, Error{
    case invalidUsername    = "This username created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete request. Check internet connection."
    case invalidResponse    = "Invalid response from server. Please try again later."
    case invalidData        = "The data from server is invalid. Please try again later."
    case unableToFavorite   = "There are error favoriting this user. Please try again later."
    case alreadyInFavorites = "This user already in Favorites"
}
