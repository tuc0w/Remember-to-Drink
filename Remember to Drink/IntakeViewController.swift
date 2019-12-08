//
//  IntakeViewController.swift
//  Drink More Water
//
//  Created by Andreas Behrend on 05.12.19.
//  Copyright © 2019 Andreas Behrend. All rights reserved.
//

import Cocoa
import CoreData

class IntakeViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.updateView()
    }

    // notification interval
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    // daily goal
    @IBOutlet weak var dailyGoalLabel: NSTextField!
    
    @IBOutlet weak var dailyGoalStepper: NSStepper!
    
    @IBAction func dailyGoal(_ sender: NSStepper) {
        let goal = dailyGoalStepper.intValue
        if (goal > 0) {
            dailyGoalLabel.stringValue = String(goal)
        } else {
            dailyGoalLabel.stringValue = "---"
        }
    }
    
    @IBAction func save(_ sender: NSButton) {
        self.saveConfig()
    }
    
    // next notification
    @IBOutlet weak var nextNotificationLabel: NSTextField!
    
    // intake
    @IBOutlet var intakeLabel: NSTextField!
    
    @IBAction func increaseIntake(_ sender: NSButton) {
        DataManager().increaseIntake()
        self.updateView()
    }
    
    @IBOutlet var overallIntakeLabel: NSTextField!
    
    // quit
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
    
    // additional functions
    func saveConfig() {
        DataManager().saveConfig(
            intakeInterval: Defaults.interval[segmentedControl.indexOfSelectedItem],
            selectedInterval: Int64(segmentedControl.indexOfSelectedItem),
            dailyGoal: Int64(dailyGoalStepper.intValue)
        )
        self.updateView()
    }
    
    func updateView() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // notification interval
        segmentedControl.selectedSegment = appDelegate.intakeManager.selectedInterval
        
        // daily goal
        if (appDelegate.intakeManager.dailyGoal == 0) {
            dailyGoalLabel.stringValue = String("---")
        } else {
            dailyGoalLabel.stringValue = String(appDelegate.intakeManager.dailyGoal)
        }
        dailyGoalStepper.integerValue = Int(appDelegate.intakeManager.dailyGoal)
        
        // next notification
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        nextNotificationLabel.stringValue = formatter.string(for: appDelegate.intakeManager.nextNotification)!
        
        // intake
        intakeLabel.stringValue = String(appDelegate.intakeManager.intakeAmount)
        overallIntakeLabel.stringValue = String(appDelegate.intakeManager.overallIntakeAmount)
    }
}

extension IntakeViewController {
  static func freshController() -> IntakeViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("IntakeViewController")
    
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? IntakeViewController else {
      fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
