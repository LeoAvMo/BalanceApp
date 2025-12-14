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
    @Guide(.count(3))
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
/*
func createDailySuggestions(mood: Mood, tasks: [ToDoTask]) async {
    let instructions = """
        Your job is to create a list of suggestions for the user to make their tasks easier based on their mood. The suggestions need to be short (150 character maximum) and simple. Use a friendly language, and validate the user's feelings.
        """
    
    let myPrompt = Prompt {
        "Give 3 suggestions for the user to try based on their current mood. The user is in a \(mood.moodType.rawValue.lowercased()) right now."
        
        "The current user tasks in a level of how they prioritized them are: \n"
        for task in tasks {
            "- \(task.name)\n"
        }
        DailySuggestion.example
    }
    
    let session = LanguageModelSession(instructions: instructions)
}
*/
