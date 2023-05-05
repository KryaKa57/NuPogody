//
//  GameScene.swift
//  NuPogody
//
//  Created by Alisher on 03.05.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bgImage: SKSpriteNode!
    var wolf: SKSpriteNode!
    var wolf_hand: SKSpriteNode!
    var loss: SKSpriteNode!
    var brokenEgg: SKSpriteNode!
    var gameTimer: Timer!
    var gameScoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    
    var possibleDirections = ["Left-Down","Left-Up","Right-Up","Right-Down"]
    var score: Int = 0 {
        didSet {
            gameScoreLabel.text = "Текущий балл: \(score)"
        }
    }
    var lineRedUp: SKSpriteNode!
    var lineRedDown: SKSpriteNode!
    
    let textureBG = SKTexture(imageNamed: "game-bg")
    
    let textureLeft = SKTexture(imageNamed: "wolf-left")
    let textureRight = SKTexture(imageNamed: "wolf-right")
    let textureLeftUpCatch = SKTexture(imageNamed: "basket-left-up")
    let textureRightUpCatch = SKTexture(imageNamed: "basket-right-up")
    let textureLeftDownCatch = SKTexture(imageNamed: "basket-left-down")
    let textureRightDownCatch = SKTexture(imageNamed: "basket-right-down")
    
    let textureEgg = SKTexture(imageNamed: "egg")
    let textureLoss0Egg = SKTexture(imageNamed: "3-loss")
    let textureLoss1Egg = SKTexture(imageNamed: "2-loss")
    let textureLoss2Egg = SKTexture(imageNamed: "1-loss")
    let textureLoss3Egg = SKTexture(imageNamed: "0-loss")
    let textureBrokenEgg = SKTexture(imageNamed: "broken-egg")
    
    let textureBomb = SKTexture(imageNamed: "bomb")
    let textureGoldenEgg = SKTexture(imageNamed: "golden-egg")
    
    let wolfHandCategory:UInt32 = 0x1 << 0
    let eggCategory:UInt32 = 0x1 << 1
    let bombCategory:UInt32 = 0x1 << 2
    let lineRedCategory:UInt32 = 0x1 << 4
    let goldenEggCategory:UInt32 = 0x1 << 3
    
    var chanceBomb = 5
    var chanceGoldenEgg = 5
    
    override func sceneDidLoad() {
        bgImage = SKSpriteNode(texture: textureBG)
        bgImage.position = CGPoint(x: 0, y: 0)
        bgImage.zPosition = -1
        
        wolf = SKSpriteNode(texture: textureLeft)
        wolf.position = CGPoint(x: 0 - (wolf.size.width) * 0.6, y: (wolf.size.height) / 2 - (self.frame.size.height) / 2 * 0.8)
        
        wolf_hand = SKSpriteNode(texture: textureLeftDownCatch)
        wolf_hand.position = CGPoint(x: 0 - (wolf.size.width) * 1.3 , y: (wolf.size.height) / 2.4 - (self.frame.size.height) / 2 * 0.8)
        
        loss = SKSpriteNode(texture: textureLoss0Egg)
        loss.position = CGPoint(x: self.frame.size.width / 2 - 400, y: self.frame.size.height / 2 - 300)
        
        gameScoreLabel  = SKLabelNode(text: "Текущий балл: 0")
        gameScoreLabel.position = CGPoint(x: self.frame.size.width / 2 - 400, y: self.frame.size.height / 2 - 150)
        gameScoreLabel.fontColor = UIColor.black
        gameScoreLabel.fontName = "Arial"
        gameScoreLabel.fontSize = 48
         
        highScoreLabel  = SKLabelNode(text: "Рекорд: \(UserDefaults.standard.integer(forKey: "highScore"))")
        highScoreLabel.position = CGPoint(x: self.frame.size.width / 2 - 400, y: self.frame.size.height / 2 - 80)
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.fontName = "Arial"
        highScoreLabel.fontSize = 48
        
        var timeInterval = 3
        
        if UserDefaults.standard.integer(forKey: "difficulty") == 1 {
            timeInterval = 3
            chanceBomb = 5
        } else if UserDefaults.standard.integer(forKey: "difficulty") == 2 {
            timeInterval = 2
            chanceBomb = 10
        } else {
            timeInterval = 1
            chanceBomb = 15
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(randomItem), userInfo: nil, repeats: true)
        
        wolf_hand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wolf_hand.size.width + 40, height: wolf_hand.size.height + 40))
        wolf_hand.physicsBody?.categoryBitMask = wolfHandCategory
        wolf_hand.physicsBody?.contactTestBitMask = eggCategory
        wolf_hand.physicsBody?.collisionBitMask = 0
        
        lineRedUp = SKSpriteNode(color: scene!.backgroundColor, size: CGSize(width: self.frame.width, height: 1))
        lineRedUp.yScale = 1
        lineRedUp.position = CGPoint(x: 0, y: -18)
        lineRedUp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        lineRedUp.physicsBody?.categoryBitMask = lineRedCategory
        lineRedUp.physicsBody?.contactTestBitMask = eggCategory
        lineRedUp.physicsBody?.collisionBitMask = 0
        lineRedUp.zPosition = -100
        
        lineRedDown = (lineRedUp.copy() as! SKSpriteNode)
        lineRedDown.position = CGPoint(x: 0, y: -189)
        
        brokenEgg = SKSpriteNode(texture: textureBrokenEgg)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        
        self.addChild(lineRedUp)
        self.addChild(lineRedDown)
        self.addChild(gameScoreLabel)
        self.addChild(highScoreLabel)
        self.addChild(loss)
        self.addChild(bgImage)
        self.addChild(wolf)
        self.addChild(wolf_hand)
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            /* Поворот волка и его рук в стороны в зависимости от координатов клика */
            if touch.location(in: self).x > 0 {
                wolf.texture = textureRight
                wolf.position = CGPoint(x: 0 + (wolf.size.width) * 0.6, y: (wolf.size.height) / 2 - (self.frame.size.height) / 2 * 0.8)
                if touch.location(in: self).y > 0 {
                    wolf_hand.texture = textureRightUpCatch
                    wolf_hand.position = CGPointMake(0 + (wolf.size.width) * 1.3, (wolf.size.height) - (self.frame.size.height) / 2 * 0.8)
                } else {
                    wolf_hand.texture = textureRightDownCatch
                    wolf_hand.position = CGPointMake(0 + (wolf.size.width) * 1.3, (wolf.size.height) / 2.4 - (self.frame.size.height) / 2 * 0.8)
                }
            } else {
                wolf.texture = textureLeft
                wolf.position = CGPoint(x: 0 - (wolf.size.width) * 0.6, y: (wolf.size.height) / 2 - (self.frame.size.height) / 2 * 0.8)
                if touch.location(in: self).y > 0 {
                    wolf_hand.texture = textureLeftUpCatch
                    wolf_hand.position = CGPointMake(0 - (wolf.size.width) * 1.3, (wolf.size.height) - (self.frame.size.height) / 2 * 0.8)
                } else {
                    wolf_hand.texture = textureLeftDownCatch
                    wolf_hand.position = CGPointMake(0 - (wolf.size.width) * 1.3, (wolf.size.height) / 2.4 - (self.frame.size.height) / 2 * 0.8)
                }
            }
        }
    }
    
    @objc func randomItem(){
        let randomInt = (Int.random(in: 0..<100))
        if randomInt > 100 - chanceBomb{
            addBomb()
        } else if randomInt > 100 - chanceBomb - chanceGoldenEgg{
            addEggs(isGolden: true)
        }else{
            addEggs(isGolden: false)
        }
    }
    
    @objc func addBomb(){
        possibleDirections = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleDirections) as! [String]
        
        let bomb = SKSpriteNode(texture: textureBomb)
        let bomb_pos = possibleDirections[0]
        
        var directionXaxis: CGFloat
        var velocityXaxis: Int
        
        /*TODO: Подумать над тем, как можно сделать красивее*/
        if bomb_pos == "Left-Up"{
            bomb.position = CGPoint(x: 0 - self.frame.size.width * 0.35, y: self.frame.size.width * 0.06)
            directionXaxis = (bomb.size.height) * 2.5
            velocityXaxis = 5
        } else if bomb_pos == "Left-Down" {
            bomb.position = CGPoint(x: 0 - self.frame.size.width * 0.35, y: 0 - self.frame.size.width * 0.055)
            directionXaxis = (bomb.size.height) * 2.5
            velocityXaxis = 5
        } else if bomb_pos == "Right-Up" {
            bomb.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.width * 0.06)
            directionXaxis = 0 - (bomb.size.height) * 2.5
            velocityXaxis = -6
        } else {
            bomb.position = CGPoint(x: self.frame.size.width * 0.35, y: 0 - self.frame.size.width * 0.055)
            directionXaxis = 0 - (bomb.size.height) * 2.5
            velocityXaxis = -5
        }
        
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.height)
        bomb.physicsBody?.velocity = CGVector(dx: velocityXaxis, dy: -5)
        bomb.physicsBody?.isDynamic = true
        
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = wolfHandCategory + lineRedCategory
        bomb.physicsBody?.collisionBitMask = 0
        
        self.addChild(bomb)
        
        let animationDuration:TimeInterval = 5
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveBy(x: directionXaxis, y: 0 - bomb.size.height * 1.25, duration: animationDuration))
        bomb.run(SKAction.sequence(actionArray))
    }
    
    @objc func addEggs(isGolden: Bool){
        possibleDirections = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleDirections) as! [String]
        
        let egg = SKSpriteNode(texture: isGolden ? textureGoldenEgg : textureEgg)
        let egg_pos = possibleDirections[0]
        
        var directionXaxis: CGFloat
        var velocityXaxis: Int
        
        /*TODO: Подумать над тем, как можно сделать красивее*/
        if egg_pos == "Left-Up"{
            egg.position = CGPoint(x: 0 - self.frame.size.width * 0.35, y: self.frame.size.width * 0.06)
            directionXaxis = (egg.size.height) * 2.5
            velocityXaxis = 5
        } else if egg_pos == "Left-Down" {
            egg.position = CGPoint(x: 0 - self.frame.size.width * 0.35, y: 0 - self.frame.size.width * 0.055)
            directionXaxis = (egg.size.height) * 2.5
            velocityXaxis = 5
        } else if egg_pos == "Right-Up" {
            egg.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.width * 0.06)
            directionXaxis = 0 - (egg.size.height) * 2.5
            velocityXaxis = -6
        } else {
            egg.position = CGPoint(x: self.frame.size.width * 0.35, y: 0 - self.frame.size.width * 0.055)
            directionXaxis = 0 - (egg.size.height) * 2.5
            velocityXaxis = -5
        }
        
        egg.physicsBody = SKPhysicsBody(circleOfRadius: egg.size.height)
        egg.physicsBody?.velocity = CGVector(dx: velocityXaxis, dy: -5)
        egg.physicsBody?.isDynamic = true
        
        egg.physicsBody?.categoryBitMask = isGolden ? goldenEggCategory : eggCategory
        egg.physicsBody?.contactTestBitMask = wolfHandCategory + lineRedCategory
        egg.physicsBody?.collisionBitMask = 0
        
        self.addChild(egg)
        
        let animationDuration:TimeInterval = 5
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveBy(x: directionXaxis, y: 0 - egg.size.height * 1.25, duration: animationDuration))
        egg.run(SKAction.sequence(actionArray))
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
        
        if (firstBody.categoryBitMask & wolfHandCategory) != 0 && (secondBody.categoryBitMask & eggCategory) != 0 {
            wolfCatchedEgg(eggNode: secondBody.node as! SKSpriteNode, isGolden: false)
        } else if (firstBody.categoryBitMask & eggCategory) != 0 && (secondBody.categoryBitMask & lineRedCategory) != 0 {
            wolfCrashedEgg(eggNode: firstBody.node as! SKSpriteNode)
        } else if (firstBody.categoryBitMask & bombCategory) != 0 && (secondBody.categoryBitMask & lineRedCategory) != 0 {
            firstBody.node?.removeFromParent()
        } else if (firstBody.categoryBitMask & wolfHandCategory) != 0 && (secondBody.categoryBitMask & bombCategory) != 0 {
            loss.texture = textureLoss3Egg
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            self.run(SKAction.wait(forDuration: 1.0)){ [self] in
                gameOver()
            }
        } else if (firstBody.categoryBitMask & goldenEggCategory) != 0 && (secondBody.categoryBitMask & lineRedCategory) != 0 {
            firstBody.node?.removeFromParent()
        } else if (firstBody.categoryBitMask & wolfHandCategory) != 0 && (secondBody.categoryBitMask & goldenEggCategory) != 0 {
            wolfCatchedEgg(eggNode: secondBody.node as! SKSpriteNode, isGolden: true)
        }
    }
    
    func wolfCatchedEgg(eggNode: SKSpriteNode, isGolden: Bool){
        eggNode.removeFromParent()
        score += isGolden ? 5 : 1
        if score % 10 == 0 {
            self.run(SKAction.playSoundFileNamed("egg-success-2.wav", waitForCompletion: false))
        }
        if isGolden {
            self.run(SKAction.playSoundFileNamed("egg-success-2.wav", waitForCompletion: false))
        }
    }
    func wolfCrashedEgg(eggNode: SKSpriteNode){
        eggNode.removeFromParent()
        self.brokenEgg.removeFromParent()
        if eggNode.position.x > 0{
            brokenEgg.position = CGPoint(x: self.frame.size.width / 2 - 350, y: 100 - self.frame.size.height / 2)
            self.addChild(brokenEgg)
        } else {
            brokenEgg.position = CGPoint(x: 0 - self.frame.size.width / 2 + 350, y: 100 - self.frame.size.height / 2)
            self.addChild(brokenEgg)
        }
        self.run(SKAction.playSoundFileNamed("egg-fail-2.mp3", waitForCompletion: false))
        
        if(loss.texture == textureLoss3Egg) {
            score = 0
            loss.texture = textureLoss0Egg
        } else if(loss.texture == textureLoss0Egg) {
            loss.texture = textureLoss1Egg
        } else if(loss.texture == textureLoss1Egg) {
            loss.texture = textureLoss2Egg
        } else {
            gameOver()
        }
    }
    
    func gameOver(){
        let transition = SKTransition.fade(withDuration: 0.5)
        UserDefaults.standard.set(score, forKey: "score")
        let GameOverScene = GameOverScene(fileNamed: "GameOverScene")!
        GameOverScene.scaleMode = scaleMode
        self.view?.presentScene(GameOverScene, transition: transition)
    }
}
