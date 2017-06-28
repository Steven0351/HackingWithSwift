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
    var level = -1
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var remainingAttempts: Int = 7 {
        didSet {
            if remainingAttempts == 0 {
                loadLevel()
                gameAlert(title: "You lose", message: "Try a litle harder next time")
                score -= 1
            }
            attemptsLabel.text = "Remaining Attempts: \(remainingAttempts)"
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
        level += 1
        answer = wordBank[level].uppercased()
        let questionMarks = String(repeating: "?", count: answer.characters.count)
        answerLabel.text = questionMarks
        for button in hiddenButton {
            button.isHidden = false
        }
        hiddenButton.removeAll()
        print(answer)
    }
    
    func gameAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func buttonTapped(button: UIButton) {
        hiddenButton.append(button)
        button.isHidden = true
        
        if answer.contains(button.titleLabel!.text!){
            var characters = Array(answerLabel.text!.characters)
            for (index, letter) in answer.characters.enumerated() {
                if button.titleLabel!.text! == String(letter) {
                    characters[index] = letter
                }
            }
            answerLabel.text = String(characters)
        } else {
            remainingAttempts -= 1
        }
        
        if answerLabel.text! == answer {
            score += 1
            loadLevel()
            gameAlert(title: "You win!", message: "Keep it going!")
        }
    }

}

