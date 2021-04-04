//
//  QuizService.swift
//  QuizApp_Exam
//
//  Created by Tsibulko on 25.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import Foundation


class QuizService {
    
    var delegate:QuizServiceProtocol?
    
    func getQuestions() {
        
        getRemoteJsonFile()
        
    }// end of func getQuestions()
    
    
    func getLocalJsonFile() {
        
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json")
        
        guard path != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let arrayOfQuestionsFromJson = try decoder.decode([Question].self, from: data)
            delegate?.questionsRetreived(arrayOfQuestionsFromJson)
        }
        catch {
            print("There is a mistake in Decoding Local JSON file")
        }
    } // end of func getLocalJsonFile()
    
    
    func getRemoteJsonFile() {
        
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Can't find URL")
            return
        }
        
        let session = URLSession.shared
        
        let datatask = session.dataTask(with: url!) { (data, response, error) in
            
            if data != nil && error == nil {
                
                do {
                    let decoder = JSONDecoder()
                    
                    let arrayOfQuestionsFromJson = try decoder.decode([Question].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.delegate?.questionsRetreived(arrayOfQuestionsFromJson)
                    }
                }
                catch {
                    print("Can't decode")
                }
                
            }//end of IF statement
        }//end of let datatask = session.dataTask
        
        datatask.resume()
        
    } //end of func getRemoteJsonFile()
    
    
} //end of class QuizService
