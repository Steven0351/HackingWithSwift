//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by Steven Sherry on 7/16/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var winLabel: SKLabelNode!
    
    var currentPlayer = 1
    var buildings = [BuildingNode]()
    var gameOver = false
    var player1Score: Int = 0 {
        didSet {
            viewController.player1Score.text = "Score: \(player1Score)"
        }
    }
    var player2Score: Int = 0 {
        didSet {
            viewController.player2Score.text = "Score: \(player2Score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: RandomInt(min: 2, max: 4) * 40, height: RandomInt(min: 300, max: 600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if banana != nil {
            if banana.position.y < -1000 {
                banana.removeFromParent()
                banana = nil
                
                changePlayer()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if let firstNode = firstBody.node {
            if let secondNode = secondBody.node {
                if firstNode.name == "banana" && secondNode.name == "building" {
                    bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
                }
                
                if firstNode.name == "banana" && secondNode.name == "player1" {
                    player2Score += 1
                    destroy(player: player1)
                }
                
                if firstNode.name == "banana" && secondNode.name == "player2" {
                    player1Score += 1
                    destroy(player: player2)
                }
            }
        }
    }
    
    func destroy(player: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        banana?.removeFromParent()
        
        var delay = 2.0
        
        if player1Score == 3 || player2Score == 3 {
            let winText = player1Score > player2Score ? "Player 1 Wins!" : "Player 2 Wins!"
            winLabel = SKLabelNode(fontNamed: "Avenir Next")
            winLabel.text = winText
            winLabel.fontColor = UIColor.red
            winLabel.fontSize = 78
            winLabel.position = CGPoint(x: 512, y: 384)
            winLabel.zPosition = 1
            addChild(winLabel)
            gameOver = true
            delay = 5.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            
            if self.gameOver {
                self.player1Score = 0
                self.player2Score = 0
                self.winLabel.removeFromParent()
                self.gameOver = false
                delay = 2.0
            }
            
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            newGame.player1Score = self.player1Score
            newGame.player2Score = self.player2Score
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint) {
        let buildingLocation = convert(contactPoint, to: building)
        building.hitAt(point: buildingLocation)
        
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        explosion.position = contactPoint
        addChild(explosion)
        
        banana.name = ""
        banana?.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController.activatePlayer(number: currentPlayer)
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10.0
        
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody!.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody!.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody!.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody!.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody!.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody!.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody!.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody!.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody!.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x,
                                   y: player1Building.position.y +
                                    ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody!.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody!.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody!.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x,
                                   y: player2Building.position.y +
                                    ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180.0
    }
}
