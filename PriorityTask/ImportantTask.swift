//
//  PriorityTask.swift
//  PriorityTask
//
//  Created by Leo A.Molina on 03/12/25.
//

/*
import WidgetKit
import SwiftUI

struct ImportantTaskProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ImportantTask {
        ImportantTask(date: Date(), name: "Finire il rapporto", difficulty: 1, timeDuration: 10, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> ImportantTask {
        ImportantTask(date: Date(), name: "Finire il rapporto", difficulty: 1, timeDuration: 10, configuration: ConfigurationAppIntent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<ImportantTask> {
        var entries: [ImportantTask] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ImportantTask(date: entryDate, name: "Finire il rapporto", difficulty: 1, timeDuration: 10, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct ImportantTask: TimelineEntry {
    let date: Date
    let name: String
    let difficulty: Int
    let timeDuration: Int?
    let configuration: ConfigurationAppIntent
}

struct ImportantTaskEntryView : View {
    var entry: ImportantTaskProvider.Entry
    let gradientBackground = LinearGradient(colors: [Color.blue.opacity(0.6), Color.blue], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "gauge.with.dots.needle.0percent")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                VStack (alignment: .trailing){
                    Text("Due to:")
                    Text(Date.now.formatted(date: .numeric, time: .omitted))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            HStack {
                Spacer()
                VStack (alignment: .trailing){
                    Text("10 minutes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Finire il rapporto")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .containerBackground(for: .widget) {
            gradientBackground
        }
    }
}

struct ImportantTaskWidget: Widget {
    let kind: String = "ImportantTask"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ImportantTaskProvider()) { entry in
            ImportantTaskEntryView(entry: entry)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ImportantTaskWidget()
} timeline: {
    ImportantTask(date: Date(), name: "Finire il rapporto", difficulty: 1, timeDuration: 10, configuration: .smiley)
    ImportantTask(date: Date(), name: "Finire il rapporto", difficulty: 1, timeDuration: 10, configuration: .starEyes)
}
*/
