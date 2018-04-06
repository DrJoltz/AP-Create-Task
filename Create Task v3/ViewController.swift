
import SpriteKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView! // Included by Apple
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            if let scene = StartScene(fileNamed: "StartScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

