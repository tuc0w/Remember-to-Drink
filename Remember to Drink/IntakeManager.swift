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
    
    let identifier = "drinkMoreWater-\(Bundle.main.buildVersionNumber ?? "1")"
    var intakeAmount = Defaults.amount
    var intakeInterval = Defaults.interval[Defaults.selectedInterval]
    let intakeNotification = NSUserNotification()
    let notificationCenter = NSUserNotificationCenter.default
    var overallIntakeAmount = Defaults.overall
    var selectedInterval = Defaults.selectedInterval
    
    override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        DataManager().increaseIntake()
        intakeNotification.informativeText = "Heute schon \(intakeAmount)x getrunken"
        self.schedule(_seconds: intakeInterval)
    }
    
    func createNotification() {
        intakeNotification.identifier = identifier
        intakeNotification.title = "Remember to Drink"
        intakeNotification.subtitle = "Es ist an der Zeit etwas zu trinken!"
        if (intakeAmount == 0) {
            intakeNotification.informativeText = "Du hast heute noch nichts getrunken"
        } else {
            intakeNotification.informativeText = "Heute schon \(intakeAmount)x getrunken"
        }
        intakeNotification.soundName = NSUserNotificationDefaultSoundName
        intakeNotification.hasActionButton = true
        intakeNotification.actionButtonTitle = "Ich habe getrunken"
    }
    
    func schedule(_seconds: Double) {
        intakeNotification.deliveryDate = Date(timeIntervalSinceNow: _seconds)
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
