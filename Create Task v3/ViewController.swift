
import SpriteKit

// This class was included by Apple in the Spritekit template, but I modified what scene is launched and its scalemode
class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
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

