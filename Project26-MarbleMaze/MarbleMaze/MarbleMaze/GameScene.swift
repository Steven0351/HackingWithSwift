//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Steven Sherry on 7/14/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionType: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager = CMMotionManager()
    var scoreLabel: SKLabelNode!
    var isGameOver = false
    let levelArray = ["level1", "level2"]
    var levelPosition = 0
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        loadLevel(levelArray[levelPosition])
        createPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
            for node in nodes(at: location) {
                if node.name == "replay" {
                    restartGame()
                }
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if (arch(i386) || arch(x86_64))
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
            }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollided(with: contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollided(with: contact.bodyA.node!)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody!.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [unowned self] in
                self.createPlayer()
                self.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            
            let move = SKAction.move(to: CGPoint(x: 512, y: 384), duration: 0.5)
            let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 0.5)
            let scale = SKAction.scale(to: 1000, duration: 0.5)
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
            let actions = SKAction.group([move, spin, scale, fade])
            
            if levelPosition == levelArray.count - 1 {
                
                node.run(actions) { [unowned self] in
                    self.removeAllChildren()
                    let gameOverSprite = SKSpriteNode(imageNamed: "gameOver")
                    gameOverSprite.position = CGPoint(x: 512, y: 384)
                    gameOverSprite.zPosition = 1
                    let replay = SKLabelNode(fontNamed: "Chalkduster")
                    replay.text = "Replay"
                    replay.fontSize = 14
                    replay.position = CGPoint(x: 512, y: 284)
                    replay.name = "replay"
                    self.addChild(replay)
                    self.addChild(gameOverSprite)
                    self.isGameOver = true
                }
            } else {
                node.run(actions) { [unowned self] in
                    self.motionManager.stopAccelerometerUpdates()
                    self.levelPosition += 1
                    self.removeAllChildren()
                    self.loadLevel(self.levelArray[self.levelPosition])
                    self.createPlayer()
                }
                
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.linearDamping = 0.5
        
        player.physicsBody!.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody!.contactTestBitMask = CollisionType.star.rawValue | CollisionType.vortex.rawValue |
            CollisionType.finish.rawValue
        player.physicsBody!.collisionBitMask = CollisionType.wall.rawValue
        addChild(player)
    }
    
    func createBlock(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody!.categoryBitMask = CollisionType.wall.rawValue
        node.physicsBody!.isDynamic = false
        addChild(node)
    }
    
    func createVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.isDynamic = false
        
        node.physicsBody!.categoryBitMask = CollisionType.vortex.rawValue
        node.physicsBody!.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody!.collisionBitMask = 0
        addChild(node)
    }
    
    func createStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.isDynamic = false
        node.physicsBody!.categoryBitMask = CollisionType.star.rawValue
        node.physicsBody!.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createFinish(at position: CGPoint) {
        let node  = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.isDynamic = false
        
        node.physicsBody!.categoryBitMask = CollisionType.finish.rawValue
        node.physicsBody!.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createBackground(withImage image: String) {
        let background = SKSpriteNode(imageNamed: image)
        background.position = CGPoint(x: 512, y: 364)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
    }
    
    func addLevelComponent(withLetter letter: Character, at position: CGPoint) {
        switch letter{
        case "x":
            createBlock(at: position)
        case "v":
            createVortex(at: position)
        case "s":
            createStar(at: position)
        case "f":
            createFinish(at: position)
        default:
            break
        }
    }
    
    func restartGame() {
        removeAllChildren()
        score = 0
        levelPosition = 0
        loadLevel(levelArray[levelPosition])
        createPlayer()
    }
    
    func loadLevel(_ file: String) {
        
        createBackground(withImage: "background.jpg")
        createScoreLabel()
        
        motionManager.startAccelerometerUpdates()
        
        if let levelPath = Bundle.main.path(forResource: file, ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")
                for (row, line) in lines.reversed().enumerated() {
                    for (column, letter) in line.characters.enumerated() {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) - 32)
                        print(position)
                        addLevelComponent(withLetter: letter, at: position)
                    }
                }
            }
        }
    }
}
