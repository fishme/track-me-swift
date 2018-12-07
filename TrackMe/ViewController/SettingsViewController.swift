//
//  SettingsViewController.swift
//  TrackMe
//
//  Created by David Hohl on 13.12.17.
//  Copyright © 2018 David Hohl. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var database: DatabaseService!
    
    @IBAction func restAppBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Reset", message: "Yeah I want to reset the app!", preferredStyle: UIAlertControllerStyle.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.database.resetDB()
            self.view.makeToast("Reset done")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.view.makeToast("I did nothing!")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // init database
        self.database = DatabaseService();
        self.database.connect();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}
