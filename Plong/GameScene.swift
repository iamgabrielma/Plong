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
    
    func createParallaxBG(){
        
        let bgTop = SKSpriteNode(color: UIColor(hue: 0.50, saturation: 0.10, brightness: 0.94, alpha: 1), size: CGSize(width: self.frame.width * 0.67, height: self.frame.height))
        let bgBottom = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: self.frame.width * 0.33, height: self.frame.height))
        // By default, nodes have the anchor point X:0.5, Y:0.5, they calculate their position from their horizontal and vertical center
        // If X:0.5, Y:1 so that they measure from their center top instead, makes it easier to position because one part of the sky will take up 67% of the screen and the other part will take up 33%
        bgTop.anchorPoint = CGPoint(x: 0.5, y: 1)
        bgBottom.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        bgTop.position = CGPoint(x: self.frame.width, y: self.frame.midY)
        bgBottom.position = CGPoint(x: self.frame.width, y: bgTop.frame.midY)

        addChild(bgTop)
        addChild(bgBottom)

        bgBottom.zPosition = -40
        bgTop.zPosition = -40
        
        // Positioning debug:
        //print(self.frame.width, self.frame.height) // iPhone11: 750.0 1334.0 ok
        //print(bgTop.size.width, bgTop.size.height, bgBottom.size.width, bgBottom.size.height) // 750.0 893.780029296875 750.0 440.2200012207031 ok
        
        
    }
    
    func createParallax(){
        let backgroundTexture = SKTexture(imageNamed: "plong_test_parallax_bg")

            for i in 0 ... 1 {
                let background = SKSpriteNode(texture: backgroundTexture)
                background.zPosition = -30
                background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i)) - CGFloat(1 * i))
                addChild(background)
                
                let moveDown = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 20)
                let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, moveReset])
                let moveForever = SKAction.repeatForever(moveLoop)

                background.run(moveForever)

            }
    }
    
    func createParallax2() {
        let groundTexture = SKTexture(imageNamed: "plong_test_parallax_bg_2")

        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            //ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            ground.position = CGPoint(x: 0, y: (groundTexture.size().height * CGFloat(i)) - CGFloat(1 * i))

            addChild(ground)

            //let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveDown = SKAction.moveBy(x: 0, y: -groundTexture.size().height , duration: 5)
            let moveReset = SKAction.moveBy(x: 0, y: groundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
        }
    }
    
    override func didMove(to view: SKView) {

        startGame()
        createParallaxBG()
        createParallax()
        createParallax2()
        
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
