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
            // change bullets
        }
    }
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
        
        for multiplier in 0 ..< bulletsRemaining {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position = CGPoint(x: 50 + CGFloat(multiplier * 10),
                                      y: 725)
            bullet.zPosition = 0
            bullets.append(bullet)
            addChild(bullet)
        }
        
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let bullet = bullets.popLast() else { return }
        bullet.removeFromParent()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
