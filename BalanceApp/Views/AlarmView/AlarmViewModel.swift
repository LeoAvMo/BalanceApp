//
//  AlarmViewModel.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 15/12/25.
//

import AlarmKit
import SwiftUI
import Observation
import AppIntents
import ActivityKit

@Observable
@MainActor
class AlarmViewModel {
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<TaskMetadata>
    
    var activeAlarm: Alarm?
    
    private let alarmManager = AlarmManager.shared
    
    init() {
        observeAlarms()
    }
    
    private func observeAlarms() {
        Task {
            for await alarms in alarmManager.alarmUpdates {
                if let updatedAlarm = alarms.first(where: { $0.id == self.activeAlarm?.id}) {
                    await MainActor.run {
                        self.activeAlarm = updatedAlarm
                    }
                } else if !alarms.contains(where: { $0.id == self.activeAlarm?.id}) {
                    await MainActor.run {
                        self.activeAlarm = nil
                    }
                }
            }
        }
    }
    
    func startTaskTimer(task: ToDoTask) {
        let metadata = TaskMetadata(taskName: task.name, priority: task.priority)
        startCountdown(duration: task.timeToComplete, metadata: metadata)
    }
    
    func startFreeTimer(duration: TimeInterval) {
        let metadata = TaskMetadata(taskName: "Focus Timer", priority: .medium)
        startCountdown(duration: duration, metadata: metadata)
    }
    
    func startCountdown(duration: TimeInterval, metadata: TaskMetadata) {
        let id = UUID()
        
        let alertContent = AlarmPresentation.Alert(title: LocalizedStringResource(stringLiteral: metadata.taskName), stopButton: .stopButton)
        
        let countdownContent = AlarmPresentation.Countdown(title: LocalizedStringResource(stringLiteral: metadata.taskName), pauseButton: .pauseButton)
        
        let pausedContent = AlarmPresentation.Paused(title: "Paused", resumeButton: .resumeButton)
        
        let attributes = AlarmAttributes(
                presentation: AlarmPresentation(alert: alertContent, countdown: countdownContent, paused: pausedContent),
                metadata: metadata,
                tintColor: metadata.priority.priorityColor()
        )
        
        let config = AlarmConfiguration(
            countdownDuration: .init(preAlert: duration, postAlert: nil),
            attributes: attributes,
            stopIntent: StopIntent(alarmID: id.uuidString)
        )
        
        Task {
            do {
                _ = try await alarmManager.requestAuthorization()
                
                let alarm = try await alarmManager.schedule(id: id, configuration: config)
                self.activeAlarm = alarm
            } catch {
                print(error)
            }
        }
    }
    
    func pauseActiveAlarm() {
        guard let id = activeAlarm?.id else {return}
        try? alarmManager.pause(id: id)
    }
    
    func resumeActiveAlarm() {
        guard let id = activeAlarm?.id else {return}
        try? alarmManager.resume(id: id)
    }
    
    func stopActiveAlarm() {
        guard let id = activeAlarm?.id else {return}
        try? alarmManager.cancel(id: id)
        
    }
    
    func currentRemainingTime() -> TimeInterval? {
        guard let id = activeAlarm?.id else { return nil }
        
        for activity in Activity<AlarmAttributes<TaskMetadata>>.activities {
            if activity.content.state.alarmID == id {
                switch activity.content.state.mode {
                case .countdown(let countdown):
                    return max(0, countdown.fireDate.timeIntervalSinceNow)
                case .paused(let paused):
                    return paused.totalCountdownDuration - paused.previouslyElapsedDuration
                default:
                    break
                }
            }
        }
        
        if let alarm = activeAlarm, let duration = alarm.countdownDuration?.preAlert {
            return duration
        }
        
        return nil
    }
    
    func currentFireDate() -> Date? {
        guard let id = activeAlarm?.id else { return nil }
        
        for activity in Activity<AlarmAttributes<TaskMetadata>>.activities {
            if activity.content.state.alarmID == id {
                if case .countdown(let countdown) = activity.content.state.mode {
                    return countdown.fireDate
                }
            }
        }
        
        return activeAlarm?.alertingTime
    }
    
}
