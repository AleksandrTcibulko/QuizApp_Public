//
//  ViewController.swift
//  QuizApp_Exam
//
//  Created by Tsibulko on 25.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var leadingConstraitRootStackView: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintRootStackView: NSLayoutConstraint!
    
    let quizService = QuizService()
    
    var questions = [Question]()
    
    var currentQuestionIndex = 0
    
    var numCorrect = 0
    
    var resultDialog:ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        quizService.delegate = self
        quizService.getQuestions()
        
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC")
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
    } //end of override func viewDidLoad()
    
    
    //MARK: - Slide In and Slide Out of StackView
    
    func slideInQuestion() {
        
        leadingConstraitRootStackView.constant = 1000
        trailingConstraintRootStackView.constant = -1000
        rootStackView.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.leadingConstraitRootStackView.constant = 0
            self.trailingConstraintRootStackView.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        
        leadingConstraitRootStackView.constant = 0
        trailingConstraintRootStackView.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.leadingConstraitRootStackView.constant = -1000
            self.trailingConstraintRootStackView.constant = 1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    
    //MARK: - Display Questions
    
    func displayQuestions() {
        
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        questionLabel.text = questions[currentQuestionIndex].question
        tableView.reloadData()
        slideInQuestion()
    }
    
} //end of class ViewController



//MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else {
            return 0
        }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            let question = questions[currentQuestionIndex]
            if question.answers != nil && indexPath.row < question.answers!.count {
                label!.text = question.answers![indexPath.row]
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex == indexPath.row {
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            titleText = "Wrong!"
        }
        
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        if resultDialog != nil {
            
            resultDialog?.titleText = titleText
            resultDialog?.feedbackText = question.feedback!
            resultDialog?.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
        }
    } // end of tableView(.... didSelectRowAt ... )
    
} // end of extension ViewController: UITableViewDataSource, UITableViewDelegate


//MARK: - QuizServiceProtocol Methods

extension ViewController: QuizServiceProtocol {
    
    func questionsRetreived(_ questions: [Question]) {
        
        self.questions = questions
        
        let savedIndex = StateManager.retreiveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < questions.count {
            
            currentQuestionIndex = savedIndex!
            
            let savedNumCorrect = StateManager.retreiveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                
                numCorrect = savedNumCorrect!
            }
        }
        
        displayQuestions()
    }
} // end of extension ViewController: QuizServiceProtocol


// MARK: - ResultViewControllerProtocol Methods

extension ViewController: ResultViewControllerProtocol {
    
    func resultDialogDismissed() {
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            if resultDialog != nil {
                
                resultDialog?.titleText = "Summary"
                resultDialog?.feedbackText = "You gave \(numCorrect) correct answers from \(questions.count) questions"
                resultDialog?.buttonText = "Restart"
                self.present(self.resultDialog!, animated: true, completion: nil)
                
                StateManager.clearState()
            }
        }
        else if currentQuestionIndex < questions.count {
            
            displayQuestions()
            
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        else if currentQuestionIndex > questions.count {
            
            currentQuestionIndex = 0
            numCorrect = 0
            displayQuestions()
        }
    } //end of func resultDialogDismissed()
    
} // end of extension ViewController: ResultViewControllerProtocol

