//
//  ViewController.swift
//  Timer
//
//  Created by user221491 on 2/4/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSelect: UIDatePicker!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var timeLeft: UILabel!
    
    var clock = Timer()
    var timer = Timer()
    var counter : Int?
    var dateForm = DateFormatter()
    var timeForm = DateFormatter()
    var userAlarm : Date?
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        assessBkgrd()
        timeButton.setTitle("Start Timer", for: .normal)
        dateForm.dateFormat = "EEE, dd MMM YYYY HH:mm:ss"
        timeForm.dateFormat = "HH:mm:ss"
        timeLeft.isHidden = true
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        playSound()
    }
    
    @IBAction func timeSelect(_ sender: Any) {
    }
    

    @IBAction func timeButton(_ sender: UIButton) {
        if timeButton.currentTitle! == "Start Timer" {
            userAlarm = timeSelect.date
            let hoursMins = Calendar.current.dateComponents([.hour, .minute], from: userAlarm!)
            counter = (hoursMins.hour!*3600) + (hoursMins.minute!*60)
                
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.runCountdown) , userInfo: nil, repeats: true)
        }
        else if timeButton.currentTitle! == "Stop Timer" {
            timer.invalidate()
            timeButton.setTitle("Start Timer", for: .normal)
            timeLeft.isHidden = true
        }
        else {
            timer.invalidate()
            stopAlarm()
            timeButton.setTitle("Start Timer", for: .normal)
            timeLeft.isHidden = true
        }
    }
    
    @objc func runCountdown() {
        if counter! == 0 {
            timer.invalidate()
            timeLeft.text = "Timer Complete"
            timeButton.setTitle("Stop Music", for: .normal)
            playAlarm()
        }
        else {
            timeButton.setTitle("Stop Timer", for: .normal)
            timeLeft.isHidden = false
            timeLeft.text = "Time Remaining: \(String(format: "%02d", counter!/3600)):\(String(format: "%02d",(counter!%3600)/60)):\(String(format: "%02d",(counter!%60)))"
            counter! -= 1
        }
    }
    
    @objc func tick() {
        timeLabel.text = dateForm.string(from: Date())
        assessBkgrd()
    }
    
    @objc func assessBkgrd(){
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0...11: back.image = UIImage(named: "day")
            timeLeft.textColor = UIColor.black
            break
        case 12...23: back.image = UIImage(named: "night")
            timeLeft.textColor = UIColor.white
            break
        default: back.image = UIImage(named: "day")
            timeLeft.textColor = UIColor.black
            break
        }
    }
    
    @objc func playSound() {
        guard let path = Bundle.main.path(forResource: "R2D2", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func playAlarm() {
        player?.play()
    }
    
    @objc func stopAlarm() {
        player?.stop()
    }
    
}

