
import Cocoa
import SpriteKit
import GameplayKit
import Foundation


class StartScene: SKScene {
    let startButton = SKLabelNode(text: "Press Space Bar to start!")
    
    override func didMove(to view: SKView) {
        startButton.fontSize = 50
        startButton.fontColor = .white
        startButton.position = CGPoint(x: 0, y: 0)
        addChild(startButton)
    }
}
