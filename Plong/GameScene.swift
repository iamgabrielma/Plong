//
//  GameScene.swift
//  Plong
//
//  Created by Gabriel Maldonado Almendra on 1/9/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    /// Game Objects
    var ball = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var mainPaddle = SKSpriteNode()
    /// UI Objects
    var enemyLabel = SKLabelNode()
    var mainLabel = SKLabelNode()
    var score = [Int]()
    /// Set initial game score and labels
    func startGame(){
        score = [0,0]
        mainLabel.text = "\(score[0])"
        enemyLabel.text = "\(score[1])"
    }
    
    /// Parallax 1/3 - Background
    func createParallaxBackGround(){
        
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

    }
    
    /// Parallax 2/3 - Base layer
    func createParallaxBaseLayer(){
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
    
    /// Parallax 3/3 - Detail layer
    func createParallaxDetailLayer() {
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
    
    /// Animation
    func animateLabels(_ node: SKNode){
        /// Unhide nodes
        let unHideIt = SKAction.unhide()
        let hideIt = SKAction.hide()
        /// Animate node size
        let scaleUP = SKAction.scale(to: 2, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
        let waitAction = SKAction.wait(forDuration: 0.2)
        /// Sequence the actions
        let scaleActionSequence = SKAction.sequence([unHideIt, scaleUP, scaleDown, waitAction, hideIt])
        /// Run it
        node.run(scaleActionSequence)
    }
    
    /// Initial Game Setup when game starts
    override func didMove(to view: SKView) {
        /// Game stuff:
        startGame()
        /// Parallax stuff:
        createParallaxBackGround()
        createParallaxBaseLayer()
        createParallaxDetailLayer()
        /// Border Logic:
        let screenBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenBorder.friction = 0 /// So doesn't slow down the objects that collide
        screenBorder.restitution = 1 /// So the ball bounces when hitting the screen borders
        self.physicsBody = screenBorder
        /// Ball Logic:
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        mainPaddle = self.childNode(withName: "mainPaddle") as! SKSpriteNode
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20)) /// Initial impulse
        /// Labels:
        mainLabel = self.childNode(withName: "mainLabel") as! SKLabelNode
        enemyLabel = self.childNode(withName: "enemyLabel") as! SKLabelNode
    }
    /// Determines when/where is the screen touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let loc = touch.location(in: self) /// Loc of finger in view
            mainPaddle.run(SKAction.moveTo(x: loc.x, duration: 0.2)) /// Move to X with a delayed response
        }
    }
    /// Determines when/where is the screen touched, and dragged
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self) /// Loc of finger in view
            mainPaddle.run(SKAction.moveTo(x: loc.x, duration: 0.2)) /// Move to X with a delayed response
        }
    }
    /// Logic in the Update game loop - Code here should be kept to a minimum for performance
    override func update(_ currentTime: TimeInterval) {
        #warning("TODO: Adjust enemy difficulty by adjusting delay speed")
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 1.0)) /// Enemy moves along with the ball, but a bit delayed.
        #warning("TODO: Check if -20 is a good border or should be modified")
        /// Screen bottom threeshold to score
        if ball.position.y <= (mainPaddle.position.y - 20 ){
            addScore(playerWhoWon: enemyPaddle)
        }
        /// Screen top threeshold to score
        else if ball.position.y >= (enemyPaddle.position.y - 20 ){
            addScore(playerWhoWon: mainPaddle)
        }
    }
    /// Sums score, resets the game set, trigger changes in UI and labels
    func addScore(playerWhoWon: SKSpriteNode){
        let spawn = Helpers.randomize(forType: .spawnPosition)
        ball.position = CGPoint(x: spawn, y: 0) /// Reset the ball to spawn in random X & Y = 0 position
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0) /// Remove force so it doesn't accumulate after each new ball spawn
        /// Player scores logic:
        if playerWhoWon == mainPaddle {
            score[0] += 1
            let impulse = Helpers.randomize(forType: .impulse)
            ball.physicsBody?.applyImpulse(CGVector(dx: impulse, dy: impulse))
            mainLabel.isHidden = false
            animateLabels(mainLabel)
        /// Enemy scores logic:
        } else if playerWhoWon == enemyPaddle {
            score[1] += 1
            let impulse = Helpers.randomize(forType: .impulse)
            ball.physicsBody?.applyImpulse(CGVector(dx: impulse * (-1), dy: impulse * (-1)))
            enemyLabel.isHidden = false
            animateLabels(enemyLabel)
        }
        /// Update labels
        mainLabel.text = "\(score[0])"
        enemyLabel.text = "\(score[1])"
    }
}
