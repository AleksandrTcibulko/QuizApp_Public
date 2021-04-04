//
//  ResultViewController.swift
//  QuizApp_Exam
//
//  Created by Tsibulko on 26.08.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        dialogView.layer.cornerRadius = 10
        
    } //end of override func viewDidLoad()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
            
        }, completion: nil)
    }

    
    @IBAction func dismissResultVCWindow(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 0
            
        }) { (completed) in
            
            self.dismiss(animated: true, completion: nil)
            self.delegate?.resultDialogDismissed()
        }
    }
    

} //end of class ResultViewController
