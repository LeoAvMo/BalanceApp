//
//  SuggestionGenerator.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 14/12/25.
//

import Foundation
import SwiftData
import SwiftUI
import FoundationModels

@Observable
class SuggestionGenerator {
    var dailySuggestion: DailySuggestion.PartiallyGenerated?
    var isGenerating: Bool = false
    
    func generate(mood: Mood, tasks: [ToDoTask]) async {
        guard !tasks.isEmpty else { return }
        self.isGenerating = true
        
        let instructions = """
            Your job is to create a list of suggestions for the user to make their tasks easier based on their mood. The suggestions need to be short (150 character maximum) and simple. Use a friendly language, and validate the user's feelings. Make sure that the suggestions are related to the tasks, like a way to make the task easier.
            """
        let myPrompt = Prompt {
            "Give 5 suggestions for the user to try based on their current mood. The user is in a \(mood.moodType.rawValue.lowercased()) right now."
            
            "The current user's tasks in a level of how they prioritized from most to least important are: \n"
            for task in tasks {
                "- \(task.name)\n"
            }
            "Take this priority into account when making the recommendations."
        }
        
        do {
            let session = LanguageModelSession(instructions: instructions)
            for try await suggestion in try await session.streamResponse(to: myPrompt, generating: DailySuggestion.self) {
                self.dailySuggestion = suggestion.content
            }
        } catch {
            print("Error \(error)")
        }
        self.isGenerating = false
    }
    
    
}
