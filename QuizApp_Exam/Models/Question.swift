//
//  Question.swift
//  QuizApp_Exam
//
//  Created by Tsibulko on 25.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import Foundation

struct Question:Codable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
    
}
