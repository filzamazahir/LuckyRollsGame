//
//  ViewController.swift
//  Lucky Rolls
//
//  Created by Filza Mazahir on 1/12/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var game = LuckyRollsGame()

    var motionManager: CMMotionManager!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var gridSquares: [UIButton]!
    
    @IBOutlet weak var rollThreshold: UIProgressView!
    @IBOutlet weak var rollButtonOutlet: UIButton!
    @IBOutlet weak var startBtnOutlet: UIButton!
    @IBOutlet weak var resetBtnOutlet: UIButton!
    
    @IBOutlet weak var roll1Label: UILabel!
    @IBOutlet weak var roll2Label: UILabel!
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    @IBOutlet weak var rollStrengthLabel: UILabel!
    var countDoubleRoll = 0
    
    @IBAction func startButton(sender: AnyObject) {
        print ("Start pressed")
        startBtnOutlet.enabled = false
        rollButtonOutlet.hidden = false
        rollButtonOutlet.enabled = true
        gridSquares[0].backgroundColor = UIColor.init(red: 0, green: 255, blue: 255, alpha: 0.5)
    }
    
    @IBAction func resetButton(sender: AnyObject) {
        print ("Reset pressed")
        game.resetDice()
        game.resetGame()
        roll1Label.text = "0"
        roll2Label.text = "0"
        stepsLabel.text = ""
        rollStrengthLabel.text = ""
        startBtnOutlet.enabled = true
        rollThreshold.progress = 0
        rollButtonOutlet.hidden = false
        rollButtonOutlet.enabled = false
        stepsLabel.hidden = true
        rollStrengthLabel.hidden = true
        
        for each in gridSquares {
            each.backgroundColor = UIColor.yellowColor()
        }
        
//        gridSquares[0].backgroundColor = UIColor.init(red: 0, green: 255, blue: 255, alpha: 0.5)
        
        
        
    }
    
    @IBAction func rollButton(sender: AnyObject) {
        stepsLabel.hidden = true
        rollButtonOutlet.enabled = false
        
        if game.rollNum == 1 {
            game.resetDice()
            roll1Label.text = "0"
            roll2Label.text = "0"
        }
        print("Die Rolled for Roll number \(game.rollNum)")
        
        if motionManager.deviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.02
            resetBtnOutlet.enabled = false
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {data, error in
                
                let yAccel = data!.userAcceleration.y
                
                if yAccel > 2.0 && self.game.rollNum == 1 && self.countDoubleRoll == 0 {
                    print("Double roll")
                    print("y",data!.userAcceleration.y)
                    self.motionManager.stopDeviceMotionUpdates()
                    self.updateUIOnDieRollForMin(1, andMax: 12, withYAccel: yAccel)
                    self.countDoubleRoll = 1
                    
                    self.rollStrengthLabel.text = "Double Roll Initiated!"
                    print("1st double roll")
                }
                    
                else if yAccel > 2.0 && self.game.rollNum == 2 && self.countDoubleRoll == 1 {
                    print("Double roll")
                    print("y",data!.userAcceleration.y)
                    self.motionManager.stopDeviceMotionUpdates()
                    self.updateUIOnDieRollForMin(1, andMax: 12, withYAccel: yAccel)
                    self.countDoubleRoll = 0
                    print("2nd double roll")
                }
                
                else if yAccel > 1.5 && self.countDoubleRoll == 0 {
//                    print("x",data!.userAcceleration.x)
                    print("y",data!.userAcceleration.y)
                    self.motionManager.stopDeviceMotionUpdates()
                    self.updateUIOnDieRollForMin(1, andMax: 6, withYAccel: yAccel)
                    print("Regular roll")
                    
                    
                    
                } else if yAccel > 0 {
                        let rollStrength = Double(yAccel/2)*100
                        self.rollStrengthLabel.text = "Roll Harder! "+String(format: "%.0f", rollStrength)+"%"
                    
                }
                self.rollStrengthLabel.hidden = false
                self.rollThreshold.progress = Float(yAccel/2)
                
                
            })
        }
        
    }
    
    
    func updateUIOnDieRollForMin(min: Int, andMax: Int, withYAccel: Double){
        
        let rand = Int(arc4random_uniform(UInt32(andMax))) + min
        if self.game.rollNum == 1{
            self.game.die1 = rand
            self.roll1Label.text = "\(rand)"
            self.game.rollNum = 2  //change to second roll
        } else {
            self.game.die2 = rand
            self.roll2Label.text = "\(rand)"
            self.game.rollNum = 1  //back to first roll
            self.updateUI()
            
        }
        
        var rollStrength = Double(withYAccel/2)*100
        if rollStrength > 100 {
            rollStrength = 100
        }
        self.rollStrengthLabel.text = "Nice Roll! "+String(format: "%.0f", rollStrength)+"%"
        self.rollButtonOutlet.enabled = true
        
    }
    
    func updateUI () {
        stepsLabel.hidden = false
        gridSquares[game.playerPosition-1].backgroundColor = UIColor.lightGrayColor()
        
        game.updatePlayerPosition()
       
        //update labels
        let steps = game.die1 - game.die2
        if steps >= 0 {
            stepsLabel.text = "Move \(steps) forward!"
        }
        else {
            stepsLabel.text = "Ooops! Move \(-steps) back!"
        }
        
        // If game is over
        if game.playerPosition == 25 {
            rollButtonOutlet.hidden = true
            rollStrengthLabel.hidden = true
            stepsLabel.text = "Game Over! You won in \(game.turnCount) turns!"
        }
        
        
        gridSquares[game.playerPosition-1].backgroundColor = UIColor.init(red: 0, green: 255, blue: 255, alpha: 0.5)
        resetBtnOutlet.enabled = true
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        rollButtonOutlet.enabled = false
        stepsLabel.hidden = true
        rollStrengthLabel.hidden = true
        stepsLabel.text = ""
        rollStrengthLabel.text = ""
        titleLabel.font = UIFont (name: "HelveticaNeue-UltraLight", size: 40)
        for each in gridSquares {
            each.layer.cornerRadius = 10
        }
        rollButtonOutlet.layer.cornerRadius = 10
        roll1Label.layer.cornerRadius = 10.0
        roll2Label.layer.cornerRadius = 10.0
        roll1Label.clipsToBounds = true
        roll2Label.clipsToBounds = true
    
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

