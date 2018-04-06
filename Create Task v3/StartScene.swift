
import SpriteKit
import Foundation


class StartScene: SKScene {
    let startButton = SKLabelNode(text: "Press Enter to start!")
    let scoreButton = SKLabelNode(text: "Previous Score: 0")
    let accuracyButton = SKLabelNode(text: "Previous Accuracy: 0%")
    
    override func didMove(to view: SKView) {
        startButton.fontSize = 50
        startButton.fontColor = .red
        startButton.fontName = "Arial-BoldMT"
        startButton.position = CGPoint(x: 0, y: -100)
        
        scoreButton.fontSize = 30
        scoreButton.fontColor = .black
        scoreButton.fontName = "Arial-BoldMT"
        scoreButton.position = CGPoint(x: 0, y: 200)
        scoreButton.text = "Previous Score: " + String(GameScene.score)
        
        accuracyButton.fontSize = 30
        accuracyButton.fontColor = .black
        accuracyButton.fontName = "Arial-BoldMT"
        accuracyButton.position = CGPoint(x: 0, y: 100)
        if GameScene.shotsFired != 0 {
            accuracyButton.text = "Previous Accuracy: " + String((Float(GameScene.score) / Float(GameScene.shotsFired)) * 100) + "%"
        }
        else {
            accuracyButton.text = "Previous Accuracy: 0%"
        }
        
        GameScene.shotsFired = 0
        GameScene.score = 0
        addChild(startButton)
        addChild(scoreButton)
        addChild(accuracyButton)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x24: // Enter
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
                
            }
        default:
            break
        }
    }
}
