//
//  DataManager.swift
//  Remember to Drink
//
//  Created by Andreas Behrend on 06.12.19.
//  Copyright © 2019 Andreas Behrend. All rights reserved.
//

import Cocoa
import CoreData
import Foundation

class DataManager: NSObject  {
    
    func run() {
        self.createConfigIfNotExists()
        self.loadConfig()
        self.getTodaysIntake()
    }
    
    func createConfigIfNotExists() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Config"
        
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            guard results.count >= 1 else {
                throw DataError.noConfigFound
            }
        } catch {
            let selectedInterval = Defaults.selectedInterval
            let interval = Defaults.interval[selectedInterval]
            let dailyGoal = Defaults.dailyGoal
            
            self.saveConfig(
                intakeInterval: interval,
                selectedInterval: Int64(selectedInterval),
                dailyGoal: Int64(dailyGoal)
            )
            print(error)
        }
    }
    
    func saveConfig(intakeInterval: Double, selectedInterval: Int64, dailyGoal: Int64) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Config"
        
        guard let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
        }
        
        let newConfig = NSManagedObject(entity: newEntity, insertInto: context)
        let timestamp = NSDate().timeIntervalSince1970
        
        newConfig.setValue(timestamp, forKey: "created")
        newConfig.setValue(dailyGoal, forKey: "dailyGoal")
        newConfig.setValue(intakeInterval, forKey: "intakeInterval")
        newConfig.setValue(selectedInterval, forKey: "selectedInterval")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        appDelegate.intakeManager.dailyGoal = Int(dailyGoal)
        appDelegate.intakeManager.intakeInterval = intakeInterval
        appDelegate.intakeManager.selectedInterval = Int(selectedInterval)

        appDelegate.intakeManager.restart()
    }
    
    func loadConfig() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Config"
        
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            guard results.count == 1 else {
                return
            }
            
            let config = results[0]
            appDelegate.intakeManager.dailyGoal = config.value(forKey: "dailyGoal") as! Int
            appDelegate.intakeManager.intakeInterval = config.value(forKey: "intakeInterval") as! Double
            appDelegate.intakeManager.selectedInterval = config.value(forKey: "selectedInterval") as! Int
            
        } catch {
            print(error)
        }
    }
    
    func increaseIntake() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Intake"
        
        guard let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
        }
        
        let newRow = NSManagedObject(entity: newEntity, insertInto: context)
        let date = Date()
        
        newRow.setValue(date, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        appDelegate.intakeManager.intakeAmount += 1
        appDelegate.intakeManager.overallIntakeAmount += 1
        
        if (
            appDelegate.intakeManager.dailyGoal > 0
            && appDelegate.intakeManager.intakeAmount == appDelegate.intakeManager.dailyGoal
        ) {
            appDelegate.intakeManager.sendDailyGoalReachedNotification()
        }
    }
    
    func getTodaysIntake() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entityName = "Intake"
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            
            guard results.count > 0 else {
                return
            }
                        
            var count = 0
            for result in results {
                let date = result.value(forKey: "date") as! Date
                if (Calendar.current.isDateInToday(date)) {
                    count += 1
                }
            }
            
            appDelegate.intakeManager.intakeAmount = count
            appDelegate.intakeManager.overallIntakeAmount = results.count
        } catch {
            print(error)
        }
    }
}
