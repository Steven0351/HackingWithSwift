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
        
        for multiplier in 0 ..< bulletsRemaining {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position = CGPoint(x: 50 + CGFloat(multiplier * 10),
                                      y: 725)
            bullet.zPosition = 0
            bullets.append(bullet)
            addChild(bullet)
        }
        
        createTargets(perRow: 0)
        
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        
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
    
    func createTargets(perRow targets: Int) {
        print(targets)
        let topAndBottomStart = CGFloat(-55)
        let middleStart = CGFloat(1084)
        
        let bottomRow = CGFloat(100)
        let middleRow = CGFloat(340)
        let topRow = CGFloat(590)
        
        let bigSpeedInSeconds = 8.0
        let mediumSpeedInseconds = 5.0
        let smallSpeedInSeconds = 2.0
        
        
        
        var goodTarget: SKSpriteNode!
        var badTarget: SKSpriteNode!
        var otherTarget: SKSpriteNode!
        
//        let goodRandomInt = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
//        let badRandomInt = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
//        
//        switch goodRandomInt {
//        case 0:
//            goodTarget = SKSpriteNode(imageNamed: "goodTargetBig")
//            goodTarget.name = "goodBig"
//        case 1:
//            goodTarget = SKSpriteNode(imageNamed: "goodTargetMedium")
//            goodTarget.name = "goodMedium"
//        case 2:
//            goodTarget = SKSpriteNode(imageNamed: "goodTargetSmall")
//            goodTarget.name = "goodSmall"
//        default:
//            return
//        }
//        
//        switch badRandomInt {
//        case 0:
//            badTarget = SKSpriteNode(imageNamed: "badTargetBig")
//            badTarget.name = "bad"
//        case 1:
//            badTarget = SKSpriteNode(imageNamed: "badTargetMedium")
//            badTarget.name = "bad"
//        case 2:
//            badTarget = SKSpriteNode(imageNamed: "badTargetSmall")
//            badTarget.name = "bad"
//        default:
//            return
//        }
        
        goodTarget = SKSpriteNode(imageNamed: "goodTargetBig")
        badTarget = SKSpriteNode(imageNamed: "badTargetBig")
        otherTarget = SKSpriteNode(imageNamed: "goodTargetBig")
        
        goodTarget.position = CGPoint(x: topAndBottomStart, y: bottomRow)
        badTarget.position = CGPoint(x: topAndBottomStart, y: topRow)
        otherTarget.position = CGPoint(x: middleStart, y: middleRow)
        
        addChild(goodTarget)
        addChild(badTarget)
        addChild(otherTarget)
        
        goodTarget.run(SKAction.move(to: CGPoint(x: middleStart, y: goodTarget.position.y), duration: bigSpeedInSeconds))
        badTarget.run(SKAction.move(to: CGPoint(x: middleStart, y: badTarget.position.y), duration: mediumSpeedInseconds))
        otherTarget.run(SKAction.move(to: CGPoint(x: topAndBottomStart, y: middleRow), duration: smallSpeedInSeconds))
        
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
    }
}
