//
//  GameScene.swift
//  Plong
//
//  Created by Gabriel Maldonado Almendra on 1/9/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    
    var enemyLabel = SKLabelNode()
    var mainLabel = SKLabelNode()
    
    var score = [Int]()
    
    func startGame(){
        // reset score
        score = [0,0]
        mainLabel.text = "\(score[0])"
        enemyLabel.text = "\(score[1])"
    }
    
    override func didMove(to view: SKView) {

        startGame()
        
        // Border Logic:
        let screenBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenBorder.friction = 0
        screenBorder.restitution = 1 // So the ball bounces.
        self.physicsBody = screenBorder
        
        // Ball Logic:
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        // In quadrants, the bigger dx and dy the impulse will be bigger. This 20/20 launches in a 45º
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        
        // Labels:
        mainLabel = self.childNode(withName: "mainLabel") as! SKLabelNode
        enemyLabel = self.childNode(withName: "enemyLabel") as! SKLabelNode
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Determine where screen is touched:
        for touch in touches {
            let loc = touch.location(in: self) // loc of finger in view
            
            mainPaddle.run(SKAction.moveTo(x: loc.x, duration: 0.2))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Determine where screen is touched and dragged:
        for touch in touches {
            let loc = touch.location(in: self) // loc of finger in view
            
            mainPaddle.run(SKAction.moveTo(x: loc.x, duration: 0.2))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Enemy should move along with the ball but a bit delayed:
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
        // Keep code here to a minimum for performance reasons.
        // Lower of screen
        if ball.position.y <= (mainPaddle.position.y - 20 ){
            addScore(playerWhoWon: enemyPaddle)
        }
        else if ball.position.y >= (enemyPaddle.position.y - 20 ){
            addScore(playerWhoWon: mainPaddle)
        }
    }
    
    func addScore(playerWhoWon: SKSpriteNode){
        
        // reset ball impulse so doesn't accumulate indefinitely
        ball.position = CGPoint(x: 0, y: 0) // reset to the center
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // remove force
        
        if playerWhoWon == mainPaddle {
            score[0] += 1
            // TODO: randomize this
            ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))
        } else if playerWhoWon == enemyPaddle {
            score[1] += 1
            // TODO: randomize this
            ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))
        }
        // Update labels
        mainLabel.text = "\(score[0])"
        enemyLabel.text = "\(score[1])"
        
        // DEBUG:
        // print(score)
    }
}
