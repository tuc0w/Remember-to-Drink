//
//  IntakeManager.swift
//  Drink More Water
//
//  Created by Andreas Behrend on 05.12.19.
//  Copyright © 2019 Andreas Behrend. All rights reserved.
//

import Cocoa
import Foundation

class IntakeManager: NSObject, NSUserNotificationCenterDelegate {
    
    var dailyGoal = Defaults.dailyGoal
    let identifier = "drinkMoreWater-\(Bundle.main.buildVersionNumber ?? "1")"
    var intakeAmount = Defaults.amount
    var intakeInterval = Defaults.interval[Defaults.selectedInterval]
    let intakeNotification = NSUserNotification()
    var nextNotification = Date(timeIntervalSinceNow: Defaults.interval[Defaults.selectedInterval])
    let notificationCenter = NSUserNotificationCenter.default
    var overallIntakeAmount = Defaults.overall
    var selectedInterval = Defaults.selectedInterval
    
    override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch (notification.activationType) {
            case .actionButtonClicked:
                DataManager().increaseIntake()
                intakeNotification.informativeText = "Heute schon \(intakeAmount)x getrunken"
                self.schedule(_seconds: intakeInterval)
                break
            case .additionalActionClicked:
                if (intakeAmount > 0) {
                    intakeNotification.informativeText = "Heute schon \(intakeAmount)x getrunken"
                }
                self.schedule(_seconds: intakeInterval)
                break
            default:
                break
        }
    }
    
    func createNotification() {
        intakeNotification.identifier = identifier
        intakeNotification.title = "Remember to Drink"
        intakeNotification.subtitle = "Zeit etwas zu trinken!"
        if (intakeAmount == 0) {
            intakeNotification.informativeText = "Noch nichts getrunken"
        } else {
            intakeNotification.informativeText = "\(intakeAmount)x getrunken"
        }
        intakeNotification.soundName = NSUserNotificationDefaultSoundName
        intakeNotification.hasActionButton = true
        intakeNotification.actionButtonTitle = "Ich habe getrunken"
        intakeNotification.otherButtonTitle = "Später"
    }
    
    func sendDailyGoalReachedNotification() {
        let dailyGoalReachedNotification = NSUserNotification()
        dailyGoalReachedNotification.identifier = "daily-goal-reached"
        dailyGoalReachedNotification.title = "Remember to Drink"
        dailyGoalReachedNotification.subtitle = "Ziel erreicht!"
        dailyGoalReachedNotification.informativeText = "\(intakeAmount)x getrunken"
        dailyGoalReachedNotification.soundName = NSUserNotificationDefaultSoundName
        dailyGoalReachedNotification.hasActionButton = false
        
        let deliveryDate = Date(timeIntervalSinceNow: Defaults.dailyGoalDelay)
        dailyGoalReachedNotification.deliveryDate = deliveryDate
        notificationCenter.scheduleNotification(dailyGoalReachedNotification)
    }
    
    func schedule(_seconds: Double) {
        let date = Date(timeIntervalSinceNow: _seconds)
        
        intakeNotification.deliveryDate = date
        nextNotification = date
        notificationCenter.scheduleNotification(intakeNotification)
    }
    
    func start() {
        self.schedule(_seconds: intakeInterval)
    }
    
    func stop() {
        notificationCenter.removeScheduledNotification(intakeNotification)
    }
    
    func restart() {
        self.stop()
        self.start()
    }
    
    func run() {
        self.createNotification()
        self.start()
    }
}
