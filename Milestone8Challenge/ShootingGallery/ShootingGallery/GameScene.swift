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
            if bulletsRemaining <= 0 {
                reloadLabel.fontColor = UIColor.white
                return
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
    var timeLabel: SKLabelNode!

    // - MARK: Overriden Methods
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
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
        reloadLabel.fontColor = UIColor.clear
        addChild(reloadLabel)
        
//        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
        
//        print(gameTimer.timeInterval)
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
        }
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // - TODO: Destroy targets
        
        for node in nodesAtPoint {
            if node.isEqual(to: reloadLabel) {
                reload()
                return
            } else if bulletsRemaining > 0 {
                bulletsRemaining -= 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                    for child in self.children {
                        if let childName = child.name {
                            if !childName.contains("bad") || !childName.contains("good") {
                                self.runTargets()
                            }
                        }
                    }
            }
        }
        nextSequenceQueued = true
    }
    
    // - MARK: Game Methods
    
    func createTarget(at rowPosition: CGPoint, forceBadTarget: ForceBadTarget = .random) {
        
//        var goodTarget: SKSpriteNode!
//        var badTarget: SKSpriteNode!
//        var otherTarget: SKSpriteNode!
        
        var target: SKSpriteNode!
        
        var targetType = RandomInt(min: 0, max: 6)
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
        
        target.position = rowPosition
        addChild(target)
        activeTargets.append(target)
        DispatchQueue.main.asyncAfter(deadline: .now() + (targetSpeed * 0.25)) { 
            if target.position.x == Row.leftStart.rawValue {
                target.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: target.position.y), duration: targetSpeed)) {
                    if target.position.x == Row.rightStart.rawValue {
                        target.removeFromParent()
                    }
                }
            } else {
                target.run(SKAction.move(to: CGPoint(x: Row.leftStart.rawValue, y: target.position.y), duration: targetSpeed)) {
                    if target.position.x == Row.leftStart.rawValue {
                        target.removeFromParent()
                    }
                }
            }
        }
        
//        goodTarget = SKSpriteNode(imageNamed: "goodTargetBig")
//        badTarget = SKSpriteNode(imageNamed: "badTargetBig")
//        otherTarget = SKSpriteNode(imageNamed: "goodTargetBig")
//        
//        goodTarget.position = rows["bottom"]!
//        badTarget.position = rows["top"]!
//        otherTarget.position = rows["middle"]!
//        
//        addChild(goodTarget)
//        addChild(badTarget)
//        addChild(otherTarget)
//        
//        goodTarget.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: goodTarget.position.y), duration: TargetSpeed.big.rawValue))
//        badTarget.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: badTarget.position.y), duration: TargetSpeed.medium.rawValue))
//        otherTarget.run(SKAction.move(to: CGPoint(x: Row.leftStart.rawValue, y: otherTarget.position.y), duration: TargetSpeed.medium.rawValue))
        
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
            reloadLabel.fontColor = UIColor.clear
        }
        bulletsRemaining += 6
    }
    
    func gameOver() {
        let gameOverNode = SKSpriteNode(imageNamed: "gameOver")
        gameOverNode.position = CGPoint(x: 512, y: 384)
        gameOverNode.zPosition = 2
        addChild(gameOverNode)
        gameTimer.invalidate()
    }
}
