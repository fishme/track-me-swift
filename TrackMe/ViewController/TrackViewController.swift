//
//  FirstViewController.swift
//  TrackMe
//
//  Created by David Hohl on 12.12.17.
//  Copyright © 2017 David Hohl. All rights reserved.
//

import UIKit
import UserNotifications
import SQLite


class TrackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var lapTableView: UITableView!
    
    // total seconds
    var totalTime:Float = 0
    
    // internal time object
    var timer = Timer()
    
    // displayed time
    var formatedTime: String = ""
    
    var defaultFormatedTime: String = "00:00:00"
    
    // database service
    var database:DatabaseService!
    
    var isTimerRunning: Int = -1
    
    var lapTimes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDB()
        initPulsView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrackingResults()
        isTimerRunning = -1
    }
    
    // init database
    func initDB () {
        self.database = DatabaseService()
        self.database.connect()
    }
    
    func initPulsView() {
        startButton.layer.cornerRadius = startButton.frame.width / 2
    }
    
    /***** ACTIONS ******/
    
    // start and pause watch
    @IBAction func startBtn(_ sender: Any) {

        if (isTimerRunning == 0) {
            timer.invalidate()
            isTimerRunning = 1;
            startButton.setTitle("START", for: .normal)
        } else if isTimerRunning == 1 || isTimerRunning == -1 {
            startButton.setTitle("PAUSE", for: .normal)
            isTimerRunning = 0;
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            
        }
        animatePulseView()
    }
    
    // reset watch
    @IBAction func resetBtn(_ sender: Any) {
        
        timer.invalidate()
        totalTime = 0
        formatedTime = defaultFormatedTime
        Label.text = String(formatedTime)
        
    }
    
    // update watch
    @objc func updateTimer() {
        totalTime += 1
        Label.text = formatTime(time: TimeInterval(totalTime))
        
    }
 
    
    // format time for us
    func formatTime(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        formatedTime = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        return formatedTime
    }
    
    // store lap to database
    @IBAction func lapBtn(_ sender: Any) {
        let insertTracking = self.database.trackingTable.insert(
            self.database.name <- String(formatedTime),
            self.database.published <- Date()
        )
        
        // basic usage
        self.view.makeToast("Saved Time")
        
        do {
            try self.database.db.run(insertTracking)
            getTrackingResults()
        } catch {
            print(error)
        }
    }
    
    // get tracking results from our database
    func getTrackingResults() {
        // reset list container
        lapTimes.removeAll()
        do {
            let query = self.database.trackingTable.order(self.database.id.desc)
            
            let tracking = try self.database.db.prepare(query)
            for track in tracking {
                lapTimes.append(track[self.database.name])
                print("id: \(track[self.database.id]) name: \(track[self.database.name]) published: \(track[self.database.published])")
            }
            lapTableView.reloadData()
            
        } catch {
            print(error)
        }
    }
    
    /*** TABLE VIEW ***/
    
    // update table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell")
        cell?.textLabel?.text = lapTimes[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTimes.count
    }
    
    /*** Animations ***/
    
    func animatePulseView(){
        var radius: CGFloat = 190
        var duration: TimeInterval = 0.8
        
        if isTimerRunning == 0 {
            radius = 120
            duration = 0.6
        }
        
        let pulse = Pulsing(numberOfPulses: 1, radius: radius, position: startButton.center)
        
        pulse.animationDuration = duration
        pulse.backgroundColor = UIColor.white.cgColor
        
        self.view.layer.insertSublayer(pulse, below: startButton.layer)
        
        
    }
}

