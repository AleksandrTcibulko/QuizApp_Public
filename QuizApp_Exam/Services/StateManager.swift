//
//  StateManager.swift
//  QuizApp_Exam
//
//  Created by Tsibulko on 26.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "numCorrectKey"
    static var questionIndexKey = "questionIndexKey"
    
    static func saveState(numCorrect:Int, questionIndex:Int) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
    }
    
    
    static func retreiveValue(key:String) -> Any? {
        
        let defaults = UserDefaults.standard
        
        return defaults.value(forKey: key)
    }
    
    
    static func clearState() {
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
    
} // end of class StateManager
