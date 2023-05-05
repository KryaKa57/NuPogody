//
//  GameOverScene.swift
//  NuPogody
//
//  Created by Alisher on 04.05.2023.
//

import SpriteKit

class GameOverScene: SKScene {
    var bgImage: SKSpriteNode!
    var playerScoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    
    override func sceneDidLoad() {
        
        let score = UserDefaults.standard.integer(forKey: "score")
        var high_score = max(UserDefaults.standard.integer(forKey: "highScore"), 0)
        if score > high_score {
            UserDefaults.standard.set(score, forKey: "highScore")
            high_score = score
            gameOverLabel = SKLabelNode(text: "Вы побили рекорд!")
        }
        gameOverLabel = SKLabelNode(text: "Игра окончена!")
        gameOverLabel.position = CGPoint(x: self.frame.size.width / 2 - 250, y: self.frame.size.height / 2 - 200)
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.fontName = "Menlo"
        gameOverLabel.fontSize = 54
        
        playerScoreLabel = SKLabelNode(text: "Заработано баллов: \(score)")
        playerScoreLabel.position = CGPoint(x: self.frame.size.width / 2 - 250, y: self.frame.size.height / 2 - 400)
        playerScoreLabel.fontColor = UIColor.black
        playerScoreLabel.fontName = "Menlo"
        playerScoreLabel.fontSize = 36
        
        highScoreLabel = SKLabelNode(text: "Рекорд: \(UserDefaults.standard.integer(forKey: "highScore"))")
        highScoreLabel.position = CGPoint(x: self.frame.size.width / 2 - 250, y: self.frame.size.height / 2 - 500)
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.fontName = "Menlo"
        highScoreLabel.fontSize = 36
        
        self.addChild(gameOverLabel)
        self.addChild(highScoreLabel)
        self.addChild(playerScoreLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "escapeButton" || nodesArray.first?.name == "escapeLabel" {
                back()
            }
        }
    }
    func back(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let MenuScene = MenuScene(fileNamed: "MenuScene")!
        MenuScene.scaleMode = scaleMode
        self.view?.presentScene(MenuScene, transition: transition)
    }
}

