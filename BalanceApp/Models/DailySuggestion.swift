//
//  DailySuggestion.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 14/12/25.
//

import Foundation
import SwiftData
import FoundationModels
import SwiftUI

@Generable
struct DailySuggestion {
    
    @Guide(description: "A list of easy, friendly, and short daily suggestions for the user to try out to help them make their tasks a little easier, taking into account their current mood.")
    @Guide(.count(5))
    var suggestions: [Suggestion]
    
    init(suggestions: [Suggestion] = []) {
        self.suggestions = suggestions
    }
    
    static let example = DailySuggestion(
        suggestions: [
            Suggestion(text: "Start with the fun win. Buy the Wicked tickets first! It takes two minutes, instantly shrinks your list, and boosts your mood.",
                       emoji: "🎟️"),
            Suggestion(text: "Text to schedule. Message Sabrina now just to agree on a time to talk later. It prevents phone tag so you can focus on studying.",
                       emoji: "💬"),
            Suggestion(text: "Prep the desk. Just open the report document and take out your exam notes. You don't have to work yet, just clear the friction!",
                       emoji: "📚"),
        ]
    )
}

