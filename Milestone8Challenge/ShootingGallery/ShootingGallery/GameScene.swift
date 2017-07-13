//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Steven Sherry on 7/9/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // - MARK: Properties
    
    let rows = ["top": CGPoint(x: Row.leftStart.rawValue, y: Row.top.rawValue),
                "middle": CGPoint(x: Row.rightStart.rawValue, y: Row.middle.rawValue),
                "bottom": CGPoint(x: Row.leftStart.rawValue, y: Row.bottom.rawValue)]
    
    var bullets = [SKSpriteNode]()
    var bulletsRemaining: Int = 6 {
        didSet {
            guard let bullet = bullets.popLast() else { return }
            bullet.removeFromParent()
            if bulletsRemaining == 0 {
                addChild(reloadLabel)
            }
        }
    }

    var activeTargets = [SKSpriteNode]()
    
    var reloadLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
           scoreLabel.text = "Score: \(score)"
        }
    }
    
    var sequence: [SequenceType]!
    var sequencePosition = 0
    var nextSequenceQueued = true
    var gameTimer: Timer!
    var timeTextLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var timeLeft: Int = 60 {
        didSet {
            timeLabel.text = "\(timeLeft)"
            if timeLeft == 0 {
                gameOver()
            }
        }
    }
    
    var gameEnded = false

    // - MARK: Overriden Methods
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 900, y: 725)
        scoreLabel.zPosition = 0
        addChild(scoreLabel)
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.text = "Reload"
        reloadLabel.position = CGPoint(x: 512, y: 725)
        reloadLabel.zPosition = 0
        reloadLabel.fontColor = UIColor.white
        
        timeTextLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeTextLabel.text = "Time Remaining:"
        timeTextLabel.fontSize = 14
        timeTextLabel.position = CGPoint(x: 110, y: 745)
        timeTextLabel.zPosition = 0
        addChild(timeTextLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.text = "\(timeLeft)"
        timeLabel.fontSize = 14
        timeLabel.position = CGPoint(x: 194, y: 745)
        timeLabel.zPosition = 0
        addChild(timeLabel)
        
        
        
        for multiplier in 0 ..< bulletsRemaining {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position = CGPoint(x: 50 + CGFloat(multiplier * 10),
                                      y: 725)
            bullet.zPosition = 0
            bullets.append(bullet)
            addChild(bullet)
        }
        
        sequence = [.twoNoBadTarget, .twoWithBadTarget, .three, .four, .random]
        
        for _ in 0 ... 500 {
            sequence.append(.random)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.runTargets()
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decreaseTime), userInfo: nil, repeats: true)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.isEqual(to: reloadLabel) {
                reload()
                return
            } else {
                for activeTarget in activeTargets {
                    if node.isEqual(to: activeTarget) {
                        
                    }
                }
                if bulletsRemaining > 0 {
                    guard let targetName = node.name else { return }
                    guard let target = node as? SKSpriteNode else { return }
                    if targetName.contains("good") {
                        goodTargetShot(targetName, target)
                        bulletsRemaining -= 1
                        return
                    } else if targetName.contains("bad") {
                        badTargetShot(target)
                        bulletsRemaining -= 1
                        return
                    } else if targetName.contains("background") {
                        bulletsRemaining -= 1
                    }
                }
            }
        }
        
        if bulletsRemaining <= 0 {
            reloadLabel.color = UIColor.white
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !gameEnded {
            if !nextSequenceQueued && activeTargets.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [unowned self] in
                    self.runTargets()
                }
                nextSequenceQueued = true
                print(nextSequenceQueued)
            }
        }
    }
    
    // - MARK: Game Methods
    
    func createTarget(at rowPosition: CGPoint, forceBadTarget: ForceBadTarget = .random) {
        
        var target: SKSpriteNode!
        
        var targetType = RandomInt(min: 0, max: 5)
        let targetSize = TargetSize(rawValue: RandomInt(min: 0, max: 2))!
        
        if forceBadTarget == .always {
            targetType = 0
        } else if forceBadTarget == .never {
            targetType = 1
        }
        
        if targetType == 0 {
            switch targetSize {
            case .big:
                target = SKSpriteNode(imageNamed: "badTargetBig")
                target.name = "badBig"
            case .medium:
                target = SKSpriteNode(imageNamed: "badTargetMedium")
                target.name = "badMedium"
            case .small:
                target = SKSpriteNode(imageNamed: "badTargetSmall")
                target.name = "badSmall"
            }
        } else {
            switch targetSize {
            case .big:
                target = SKSpriteNode(imageNamed: "goodTargetBig")
                target.name = "goodBig"
            case .medium:
                target = SKSpriteNode(imageNamed: "goodTargetMedium")
                target.name = "goodMedium"
            case .small:
                target = SKSpriteNode(imageNamed: "goodTargetSmall")
                target.name = "goodSmall"
            }
        }
        
        let targetSpeed: Double
        
        if target.name!.contains("Big") {
            targetSpeed = TargetSpeed.big.rawValue
        } else if target.name!.contains("Medium") {
            targetSpeed = TargetSpeed.medium.rawValue
        } else {
            targetSpeed = TargetSpeed.small.rawValue
        }
        
        let randomSpacing = RandomDouble(min: 0.000, max: 0.999)
        
        target.position = rowPosition
        addChild(target)
        activeTargets.append(target)
        DispatchQueue.main.asyncAfter(deadline: .now() + (targetSpeed * randomSpacing)) {
            if target.position.x == Row.leftStart.rawValue {
                target.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: target.position.y), duration: targetSpeed)) {
                        if let targetIndex = self.activeTargets.index(of: target) {
                            self.activeTargets.remove(at: targetIndex)
                        }
                        target.removeFromParent()
                }
            } else {
                target.run(SKAction.move(to: CGPoint(x: Row.leftStart.rawValue, y: target.position.y), duration: targetSpeed)) {
                        if let targetIndex = self.activeTargets.index(of: target) {
                            self.activeTargets.remove(at: targetIndex)
                        }
                        target.removeFromParent()
                }
            }
        }
        
    }
    
    func runTargets() {
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .twoNoBadTarget:
            for (_, position) in rows {
                createTarget(at: position, forceBadTarget: .never)
                createTarget(at: position, forceBadTarget: .never)
            }
        case .twoWithBadTarget:
            for (_, position) in rows {
                createTarget(at: position, forceBadTarget: .never)
                createTarget(at: position, forceBadTarget: .always)
            }
        case .three:
            for (_, position) in rows {
                createTarget(at: position)
                createTarget(at: position)
                createTarget(at: position)
            }
        case .four:
            for (_, position) in rows {
                createTarget(at: position)
                createTarget(at: position)
                createTarget(at: position)
                createTarget(at: position)
            }
        case .random:
            for (_, position) in rows {
                let numTargets = RandomInt(min: 2, max: 7)
                    for _ in 0 ... numTargets {
                        createTarget(at: position)
                    }
            }
        }
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    func reload() {
        bulletsRemaining = 0
        let maxBullets = 6
        for multiplier in bulletsRemaining ... maxBullets {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position = CGPoint(x: 50 + CGFloat(multiplier * 10), y: 725)
            bullet.zPosition = 0
            bullets.append(bullet)
            addChild(bullet)
        }
        reloadLabel.removeFromParent()
        bulletsRemaining = maxBullets

    }
    
    func goodTargetShot(_ targetName: String, _ target: SKSpriteNode) {
        
        switch targetName {
        case "goodBig":
            score += 5
        case "goodMedium":
            score += 20
        case "goodSmall":
            score += 80
        default:
            break
        }
        
        target.run(SKAction.fadeAlpha(to: 0.0, duration: 0.25)) {
            if let targetIndex = self.activeTargets.index(of: target) {
                self.activeTargets.remove(at: targetIndex)
                target.removeFromParent()
            }
        }
        
    }
    
    func badTargetShot(_ target: SKSpriteNode) {
        score -= 30
        target.run(SKAction.fadeAlpha(to: 0.0, duration: 1)) {
            if let targetIndex = self.activeTargets.index(of: target) {
                self.activeTargets.remove(at: targetIndex)
                target.removeFromParent()
            }
        }
    }
    
    func decreaseTime() {
        timeLeft -= 1
    }
    
    func gameOver() {
        let gameOverNode = SKSpriteNode(imageNamed: "gameOver")
        gameOverNode.position = CGPoint(x: 512, y: 384)
        gameOverNode.zPosition = 2
        isUserInteractionEnabled = false
        nextSequenceQueued = true
        addChild(gameOverNode)
        for (index, target) in activeTargets.enumerated().reversed() {
            activeTargets.remove(at: index)
            target.removeFromParent()
        }
        gameEnded = true
        gameTimer.invalidate()
    }
}
