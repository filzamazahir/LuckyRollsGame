//
//  LuckyRollsGame.swift
//  Lucky Rolls
//
//  Created by Filza Mazahir on 1/12/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import Foundation

class LuckyRollsGame {
    var rollNum: Int
    var playerPosition: Int
    var die1: Int
    var die2: Int
    var turnCount: Int
    
    init() {
        rollNum = 1
        playerPosition = 1
        die1 = 0
        die2 = 0
        turnCount = 0
    }
    
    
    
    
    func resetDice() {
        
        die1 = 0
        die2 = 0
        
    }
    
    func resetGame() {
        playerPosition = 1
        rollNum = 1
        turnCount = 0
    }
    
    func updatePlayerPosition(){
        let steps = die1 - die2
        turnCount++
        
        //check edge cases
        if -steps > playerPosition-1 {
            playerPosition = 1
            
        }
        else if steps+playerPosition >= 25 {
            playerPosition = 25
            
            
        }
        else {
            playerPosition += steps
        }
        
    }
    
    
    
    
    
    
    
    
    
    
}
