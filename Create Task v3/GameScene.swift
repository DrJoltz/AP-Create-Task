
import SpriteKit
import Foundation


class GameScene: SKScene {
    struct PhysicsCategory {
        static let Player: UInt32 = 0b1
        static let Laser: UInt32 = 0b10
        static let Meteor: UInt32 = 0b100
        static let Planet: UInt32 = 0b1000
    }
    
    let player = SKSpriteNode(imageNamed: "Ship")
    // http://retropedia.wikia.com/wiki/Spaceship_(Galaga)
    var lasers = [SKSpriteNode]()
    var meteors = [SKSpriteNode]()
    var planets = [SKSpriteNode]()
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    static var score: Int = 0
    static var shotsFired: Int = 0
    var scoreFactor: CGFloat = 0
    let planetDistance: CGFloat = 150
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        physicsWorld.contactDelegate = self
        addPlayer()
        spawnMeteor(delay: 1, withLoop: true)
        for i in stride(from: (self.size.height/2) as CGFloat, to: (10*planetDistance + (self.size.height/2)) , by: +100 as CGFloat) {
            generatePlanet(y: i)
        }
        
        scoreLabel.position = CGPoint(x: -400, y: 330)
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .white
        scoreLabel.text = String(GameScene.score)
        addChild(scoreLabel)
    }
    
    func setBaseProperties(body: SKPhysicsBody, category: UInt32, contactTests: [UInt32], preciseDetection: Bool) {
        body.collisionBitMask = 0
        body.friction = 0
        body.linearDamping = 0
        body.angularDamping = 0
        body.affectedByGravity = false
        body.categoryBitMask = category
        body.usesPreciseCollisionDetection = preciseDetection
        if contactTests.count > 0 {
            for contact in contactTests {
                body.contactTestBitMask |= contact
            }
        }
        else {
            body.contactTestBitMask = 0
        }
    }
    
    func addPlayer() {
        player.size = CGSize(width: 60, height: 60)
        player.name = "Player"
        let playerBody = SKPhysicsBody(texture: player.texture!, size: CGSize(width: player.size.width, height:player.size.height))
        setBaseProperties(body: playerBody, category: PhysicsCategory.Player, contactTests: [PhysicsCategory.Meteor, PhysicsCategory.Planet], preciseDetection: true)
        player.physicsBody = playerBody
        player.position = CGPoint(x: 0, y: -300)
        addChild(player)
    }
    
    func shootLaser() {
        let laser = SKSpriteNode(imageNamed: "Laser")
        // http://www.laughinggif.com/view/fy21mmomlp/9.html
        laser.size = CGSize(width: 25, height: 25)
        laser.name = "Laser"
        let laserBody = SKPhysicsBody(texture: laser.texture!, size: CGSize(width: laser.size.width, height:laser.size.height))
        setBaseProperties(body: laserBody, category: PhysicsCategory.Laser, contactTests: [PhysicsCategory.Meteor], preciseDetection: true)
        laser.physicsBody = laserBody
        laser.position = player.position
        addChild(laser)
        laserBody.velocity.dy = 1000
        lasers.append(laser)
        GameScene.shotsFired += 1
    }
    
    func spawnMeteor(delay: Double, withLoop: Bool) {
        let meteor = SKSpriteNode(imageNamed: "Meteor")
        // http://www.iconarchive.com/show/bumpy-planets-icons-by-zairaam/asteroid-icon.html
        meteor.size = CGSize(width: 100, height: 100)
        meteor.name = "Meteor"
        let meteorBody = SKPhysicsBody(circleOfRadius: 30)
        setBaseProperties(body: meteorBody, category: PhysicsCategory.Meteor, contactTests: [], preciseDetection: false)
        meteor.physicsBody = meteorBody
        meteor.zPosition = 2
        addChild(meteor)
        meteors.append(meteor)
        
        if arc4random_uniform(2) == 0 {
            meteor.position = CGPoint(x: CGFloat(arc4random_uniform(947)) - 512 , y: self.size.height/2)
            meteorBody.velocity.dx = 98.05806757 // 500 / sqrt(26)
            meteorBody.velocity.dy = -490.2903378 // -2500 / sqrt(26)
        }
        else {
            meteor.position = CGPoint(x: CGFloat(arc4random_uniform(947)) - 435 , y: self.size.height/2)
            meteorBody.velocity.dx = -98.05806757 // -500 / sqrt(26)
            meteorBody.velocity.dy = -490.2903378 // -2500 / sqrt(26)
        }
        
        if withLoop {
            let random_delay = arc4random_uniform(2) + 1
            run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.run{self.spawnMeteor(delay: Double(random_delay), withLoop: true)}]))
        }
    }
    
    func generatePlanet(y: CGFloat) {
        let planet = SKSpriteNode(imageNamed: "Planet" + String(arc4random_uniform(9) + 1))
        // All planets found at https://space-facts.com/transparent-planet-pictures/
        planet.size = CGSize(width: 125, height: 125)
        planet.name = "Planet"
        let planetBody = SKPhysicsBody(texture: planet.texture!, size: CGSize(width: planet.size.width, height: planet.size.height))
        setBaseProperties(body: planetBody, category: PhysicsCategory.Planet, contactTests: [], preciseDetection: false)
        planet.physicsBody = planetBody
        planet.position = CGPoint(x: CGFloat(arc4random_uniform(1024)) - 512, y: y)
        planetBody.velocity.dy = -250
        addChild(planet)
        planets.append(planet)
    }
    
    func meteorShower(numberOfMeteors: Int) {
        for _ in 1...numberOfMeteors {
            spawnMeteor(delay: 0, withLoop: false)
        }
    }
    
    func removeEntity(entity: SKSpriteNode) {
        if entity.name == "Meteor" {
            meteors.remove(at: meteors.index(of: entity)!)
        }
        else if entity.name == "Planet" {
            planets.remove(at: planets.index(of: entity)!)
        }
        else if entity.name == "Laser" {
            lasers.remove(at: lasers.index(of: entity)!)
        }
        entity.removeFromParent()
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 123: // Left
            if player.position.x > -470 {
                player.position.x += -60
            }
        case 124: // Right
            if player.position.x < 470 {
                player.position.x += 60
            }
        case 0x31: // Space
            shootLaser()
        default:
            break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for laser in lasers {
            if laser.position.y > (self.size.height / 2) {
                removeEntity(entity: laser)
            }
        }
        
        for meteor in meteors {
            if meteor.position.y < (self.size.height / -2) {
                removeEntity(entity: meteor)
            }
        }
        
        for planet in planets {
            if planet.position.y < (self.size.height / -2) {
                removeEntity(entity: planet)
                generatePlanet(y: planets.last!.position.y + planetDistance)
                if arc4random_uniform(50) == 0 {
                    meteorShower(numberOfMeteors: Int(arc4random_uniform(9) + 1))
                }
            }
            else {
                planet.physicsBody!.velocity.dy = -250 - (scoreFactor * 250)
            }
        }
        
        scoreLabel.text = String(GameScene.score)
        scoreFactor = CGFloat(CGFloat(GameScene.score) / 25)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKSpriteNode, let nodeB = contact.bodyB.node as? SKSpriteNode {
            if nodeA.name! == "Laser" && nodeB.name! == "Meteor" {
                removeEntity(entity: nodeA)
                removeEntity(entity: nodeB)
                GameScene.score += 1
            }
            else if nodeA.name! == "Player" && nodeB.name! == "Meteor" {
                if let scene = StartScene(fileNamed: "StartScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
            }
            else if nodeA.name! == "Player" && nodeB.name! == "Planet" {
                if let scene = StartScene(fileNamed: "StartScene") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
            }
        }
    }
}


