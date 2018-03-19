
import Cocoa
import SpriteKit
import GameplayKit
import Foundation


class StartScene: SKScene {
    let startButton = SKLabelNode(text: "Press Space Bar to start!")
    
    override func didMove(to view: SKView) {
        startButton.fontSize = 50
        startButton.fontColor = .red
        startButton.fontName = "Arial-BoldMT"
        startButton.position = CGPoint(x: 0, y: 0)
        addChild(startButton)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31: // Space
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
                
            }
        default:
            break
        }
    }
}
