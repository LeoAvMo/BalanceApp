//
//  Suggestion.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 14/12/25.
//

import Foundation
import FoundationModels

@Generable
struct Suggestion: Codable, Equatable {
    
    @Guide(description: "A friendly and brief suggestion on what should the user do according to their mood and their current tasks.")
    let text: String
    @Guide(description: "An emoji that describes the suggestion.")
    let emoji: String
    
}
