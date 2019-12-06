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
    @IBOutlet var intakeLabel: NSTextField!
    
    @IBOutlet var overallIntakeLabel: NSTextField!
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        intakeLabel.stringValue = String(appDelegate.intakeManager.intakeAmount)
        overallIntakeLabel.stringValue = String(appDelegate.intakeManager.overallIntakeAmount)
        segmentedControl.selectedSegment = appDelegate.intakeManager.selectedInterval
    }

    @IBAction func scheduleInterval(_ sender: NSSegmentedControl) {
        let selectedInterval = segmentedControl.indexOfSelectedItem
        let intakeInterval = Defaults.interval[segmentedControl.indexOfSelectedItem]
        
        DataManager().saveConfig(
            intakeInterval: intakeInterval,
            selectedInterval: Int64(selectedInterval)
        )
    }
    
    @IBAction func increaseIntake(_ sender: NSButton) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        DataManager().increaseIntake()
        intakeLabel.stringValue = String(appDelegate.intakeManager.intakeAmount)
        overallIntakeLabel.stringValue = String(appDelegate.intakeManager.overallIntakeAmount)
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
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
