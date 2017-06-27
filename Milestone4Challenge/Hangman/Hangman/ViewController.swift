//
//  ViewController.swift
//  Hangman
//
//  Created by Steven Sherry on 6/27/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    var wordBank = [String]()
    var alphabet = [String]()
    var letterButton = [UIButton]()
    var hiddenButton = [UIButton]()
    var answer: String!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            loadLevel()
        }
    }
    
    var remainingAttempts: Int = 7 {
        didSet {
            if remainingAttempts == 0 {
                gameAlert(title: "You lose", message: "Try a litle harder next time")
                score -= 1
            }
            answerLabel.text = "Remaining Attemps: \(remainingAttempts)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWordBank()
        loadAlphabet()
        loadLevel()
        for (index, subview) in view.subviews.enumerated() where subview.tag == 999 {
            let button = subview as! UIButton
            button.setTitle(alphabet[index], for: .normal)
            letterButton.append(button)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    func loadWordBank() {
        if let wordsPath = Bundle.main.path(forResource: "usa", ofType: "txt") {
            if let wordsContent = try? String(contentsOfFile: wordsPath) {
                let words = wordsContent.components(separatedBy: "\n")
                wordBank.append(contentsOf: words)
                wordBank.popLast()
                wordBank = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordBank) as! [String]
            }
        }
    }
    
    func loadAlphabet() {
        if let alphabetPath = Bundle.main.path(forResource: "alphabet", ofType: "txt") {
            if let alphabetContent = try? String(contentsOfFile: alphabetPath) {
                let temp = alphabetContent.components(separatedBy: "\n")
                alphabet.append(contentsOf: temp)
                alphabet = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: alphabet) as! [String]
            }
        }
    }
    
    func loadLevel() {
        answer = wordBank[score].uppercased()
        var questionMarks = ""
        for _ in answer.characters {
            questionMarks = questionMarks + "?"
        }
        answerLabel.text = questionMarks
        print(answer)
    }
    
    func gameAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func buttonTapped(button: UIButton) {
        if answer.contains(button.titleLabel!.text!){
            for (index, letter) in answer.characters.enumerated() {
                print(index)
                if button.titleLabel!.text! == String(letter) {
                    
                }
            }
        } else {
            print("Nayyy")
        }
        hiddenButton.append(button)
        button.isHidden = true
    }

}

