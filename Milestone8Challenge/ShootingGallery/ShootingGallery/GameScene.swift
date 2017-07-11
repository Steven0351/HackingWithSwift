//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Steven Sherry on 7/9/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SequenceType: Int {
    case twoNoBadTarget, twoWithBadTarget, three, four, random
}

enum ForceBadTarget {
    case never, always, random
}

enum TargetSize: Int {
    case big, medium, small
}

enum TargetSpeed: Double {
    case big = 8.0
    case medium = 5.0
    case small = 2.0
}

enum Row: CGFloat {
    case top = 590
    case middle = 340
    case bottom = 100
    case leftStart = -55
    case rightStart = 1084
}


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
    var reloadLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
           scoreLabel.text = "Score: \(score)"
        }
    }
    
    var sequence: [SequenceType]!
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
        
        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
        
        print(gameTimer.timeInterval)
        for multiplier in 0 ..< bulletsRemaining {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position = CGPoint(x: 50 + CGFloat(multiplier * 10),
                                      y: 725)
            bullet.zPosition = 0
            bullets.append(bullet)
            addChild(bullet)
        }
        
        sequence = [.twoNoBadTarget, .twoWithBadTarget, .three, .four, .random]
        createTarget()
        
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
    }
    
    // - MARK: Game Methods
    
    func createTarget(forceBadTarget: ForceBadTarget = .random) {
        
        var goodTarget: SKSpriteNode!
        var badTarget: SKSpriteNode!
        var otherTarget: SKSpriteNode!
        
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
            case .medium:
                target = SKSpriteNode(imageNamed: "badTargetMedium")
            case .small:
                target = SKSpriteNode(imageNamed: "badTargetSmall")
            }
        } else {
            switch targetSize {
            case .big:
                target = SKSpriteNode(imageNamed: "goodTargetBig")
            case .medium:
                target = SKSpriteNode(imageNamed: "goodTargetMedium")
            case .small:
                target = SKSpriteNode(imageNamed: "goodTargetSmall")
            }
        }
        
        target.position = rows["top"]!
        
        goodTarget = SKSpriteNode(imageNamed: "goodTargetBig")
        badTarget = SKSpriteNode(imageNamed: "badTargetBig")
        otherTarget = SKSpriteNode(imageNamed: "goodTargetBig")
        
        goodTarget.position = rows["bottom"]!
        badTarget.position = rows["top"]!
        otherTarget.position = rows["middle"]!
        
        addChild(goodTarget)
        addChild(badTarget)
        addChild(otherTarget)
        
        goodTarget.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: goodTarget.position.y), duration: TargetSpeed.big.rawValue))
        badTarget.run(SKAction.move(to: CGPoint(x: Row.rightStart.rawValue, y: badTarget.position.y), duration: TargetSpeed.medium.rawValue))
        otherTarget.run(SKAction.move(to: CGPoint(x: Row.leftStart.rawValue, y: otherTarget.position.y), duration: TargetSpeed.medium.rawValue))
        
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
            print(gameTimer.timeInterval)
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
