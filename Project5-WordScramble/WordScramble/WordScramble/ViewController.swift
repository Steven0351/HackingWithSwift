//
//  ViewController.swift
//  WordScramble
//
//  Created by Steven Sherry on 6/24/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    var count = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        let play = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        let newGame = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItems = [play, newGame]
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
                allWords.popLast()
                allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
                print(allWords)
            } else {
                defaultWords()
            }
        } else {
            defaultWords()
        }
        startGame()
    }
    
    func startGame() {
        count += 1
        title = allWords[count]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognized",
                                     errorMessage: "You can't just make them up or under three letters you know!")
                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word.characters {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                showErrorMessage(errorTitle: "Word not possible",
                                 errorMessage: "You can't spell that word from '\(title!.lowercased())'")
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word != title!.lowercased() {
            if !usedWords.contains(word) {
                return true
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original")
            }
        }
        showErrorMessage(errorTitle: "Nice try", errorMessage: "You can't just copy the word!")
        return false
    }
    
    func isReal(word: String) -> Bool {
        if word.characters.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0,
                                                            wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func defaultWords() {
        allWords = ["silkworm"]
    }

}

