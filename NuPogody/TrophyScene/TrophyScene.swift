//
//  TrophyScene.swift
//  NuPogody
//
//  Created by Alisher on 05.05.2023.
//

import SpriteKit

class TrophyScene: SKScene {
    var recordLabel: SKLabelNode!
    var trophyNode: SKSpriteNode!
    var tearNode: SKSpriteNode!
    
    let textureTrophy = SKTexture(imageNamed: "trophy-color")
    let textureTear = SKTexture(imageNamed: "tear")
    
    override func sceneDidLoad() {
        tearNode = SKSpriteNode(texture: textureTear)
        tearNode.position = CGPoint(x: 0 - 180, y: self.frame.size.height / 2 - 390)
        tearNode.zPosition = 1
        tearNode.size = CGSize(width: 100, height: 100)
        
        trophyNode = SKSpriteNode(texture: textureTrophy)
        trophyNode.position = CGPoint(x: self.frame.size.width / 2 - 500, y: self.frame.size.height / 2 - 500)
        trophyNode.zPosition = 1
        trophyNode.size = CGSize(width: 330, height: 360)
        
        recordLabel = SKLabelNode(text: "Текущий рекорд: \(UserDefaults.standard.integer(forKey: "highScore"))")
        recordLabel.position = CGPoint(x: self.frame.size.width / 2 - 200, y: self.frame.size.height / 2 - 330)
        recordLabel.fontColor = UIColor.white
        recordLabel.fontName = "Menlo"
        recordLabel.fontSize = 36
        
        self.addChild(trophyNode)
        self.addChild(recordLabel)
        
        if (UserDefaults.standard.integer(forKey: "highScore")) == 0 {
            zeroPoint()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "escapeButton" || nodesArray.first?.name == "escapeLabel" {
                back()
            } else if nodesArray.first?.name == "zeroButton" || nodesArray.first?.name == "zeroLabel" {
                zeroPoint()
            }
        }
    }
    
    func zeroPoint(){
        recordLabel.text = "Текущий рекорд: 0"
        UserDefaults.standard.set(0, forKey: "highScore")
        trophyNode.removeFromParent()
        self.addChild(tearNode)
    }
    
    func back(){
        let transition = SKTransition.fade(withDuration: 0.5)
        let MenuScene = MenuScene(fileNamed: "MenuScene")!
        MenuScene.scaleMode = scaleMode
        self.view?.presentScene(MenuScene, transition: transition)
    }
}
