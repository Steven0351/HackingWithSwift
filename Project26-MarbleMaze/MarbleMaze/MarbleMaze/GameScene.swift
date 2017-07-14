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

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 364)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        loadLevel()
        createPlayer()
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
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
    
    func loadLevel() {
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                let lines = levelString.components(separatedBy: "\n")
                for (row, line) in lines.reversed().enumerated() {
                    for (column, letter) in line.characters.enumerated() {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        if letter == "x" {
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                            node.physicsBody!.categoryBitMask = CollisionType.wall.rawValue
                            node.physicsBody!.isDynamic = false
                            addChild(node)
                        } else if letter == "v" {
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
                        } else if letter == "s" {
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "start"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.isDynamic = false
                            node.physicsBody!.categoryBitMask = CollisionType.star.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionType.player.rawValue
                            node.physicsBody?.collisionBitMask = 0
                            node.position = position
                            addChild(node)
                        } else if letter == "f" {
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
                    }
                }
            }
        }
    }
}
