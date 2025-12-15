//
//  PriorityTaskLiveActivity.swift
//  PriorityTask
//
//  Created by Leo A.Molina on 03/12/25.
//
/*
import ActivityKit
import WidgetKit
import SwiftUI

struct PriorityTaskAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PriorityTaskLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PriorityTaskAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PriorityTaskAttributes {
    fileprivate static var preview: PriorityTaskAttributes {
        PriorityTaskAttributes(name: "World")
    }
}

extension PriorityTaskAttributes.ContentState {
    fileprivate static var smiley: PriorityTaskAttributes.ContentState {
        PriorityTaskAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PriorityTaskAttributes.ContentState {
         PriorityTaskAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PriorityTaskAttributes.preview) {
   PriorityTaskLiveActivity()
} contentStates: {
    PriorityTaskAttributes.ContentState.smiley
    PriorityTaskAttributes.ContentState.starEyes
}
*/
