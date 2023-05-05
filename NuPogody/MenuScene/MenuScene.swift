//
//  MenuScene.swift
//  NuPogody
//
//  Created by Alisher on 04.05.2023.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    var bgImage: SKSpriteNode!
    var newGameButtonNode: SKSpriteNode!
    var difficultyButtonNode: SKSpriteNode!
    var soundChangeNode: SKSpriteNode!
    
    var player: AVAudioPlayer!
    
    let textureSoundOn = SKTexture(imageNamed: "sound-on")
    let textureSoundOff = SKTexture(imageNamed: "sound-off")
    
    override func sceneDidLoad() {
        
        bgImage = (self.childNode(withName: "backGround") as! SKSpriteNode)
        bgImage.zPosition = -99
        
        newGameButtonNode = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
        difficultyButtonNode = (self.childNode(withName: "difficultyButton") as! SKSpriteNode)
        
        soundChangeNode = (self.childNode(withName: "soundButton") as! SKSpriteNode)
        playSound()
    }
    
    func playSound() {
        
        guard let soundFileURL = Bundle.main.url(
            forResource: "menu-background", withExtension: "mp3"
        ) else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: soundFileURL)
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" || nodesArray.first?.name == "newGameLabel" {
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(fileNamed: "GameScene")!
                gameScene.scaleMode = scaleMode
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "difficultyButton" || nodesArray.first?.name == "difficultyLabel" {
                let transition = SKTransition.fade(withDuration: 0.5)
                let ChangeDifficultyScene = ChangeDifficultyScene(fileNamed: "ChangeDifficultyScene")!
                ChangeDifficultyScene.scaleMode = scaleMode
                self.view?.presentScene(ChangeDifficultyScene, transition: transition)
            } else if nodesArray.first?.name == "soundButton" {
                if soundChangeNode.texture == textureSoundOn{
                    player.stop()
                    soundChangeNode.texture = textureSoundOff
                } else {
                    player.play()
                    soundChangeNode.texture = textureSoundOn
                }
            } else if nodesArray.first?.name == "trophyButton" {
                //TODO: trophyScene
            }
        }
    }
}
