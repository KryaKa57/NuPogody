//
//  ChangeDifficultScene.swift
//  NuPogody
//
//  Created by Alisher on 04.05.2023.
//

import SpriteKit

class ChangeDifficultyScene: SKScene {
    var bgImage: SKSpriteNode!
    var easyButtonNode: SKSpriteNode!
    var mediumButtonNode: SKSpriteNode!
    var hardButtonNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        bgImage = (self.childNode(withName: "backGround") as! SKSpriteNode)
        bgImage.zPosition = -99
        
        easyButtonNode = (self.childNode(withName: "easyButton") as! SKSpriteNode)
        mediumButtonNode = (self.childNode(withName: "mediumButton") as! SKSpriteNode)
        hardButtonNode = (self.childNode(withName: "hardButton") as! SKSpriteNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "easyButton" || nodesArray.first?.name == "easyLabel" {
                UserDefaults.standard.set(1, forKey: "difficulty")
                back()
            } else if nodesArray.first?.name == "mediumButton" || nodesArray.first?.name == "mediumLabel" {
                UserDefaults.standard.set(2, forKey: "difficulty")
                back()
            } else if nodesArray.first?.name == "hardButton" || nodesArray.first?.name == "hardLabel" {
                UserDefaults.standard.set(3, forKey: "difficulty")
                back()
            } else if nodesArray.first?.name == "escapeButton" || nodesArray.first?.name == "escapeLabel" {
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
