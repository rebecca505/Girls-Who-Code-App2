//
//  Scene.swift
//  AR Game App
//
//  Created by GWC2 on 7/25/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import SpriteKit
import ARKit

import UIKit
import SceneKit

class Scene: SKScene {
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var levelCount = 0
    var isWorldSetUp = false
    var isWorld2SetUp = false
    var isWorld3SetUp = false
    var aim: SKSpriteNode!
    var background: SKSpriteNode!
    let gameSize = CGSize(width: 2, height: 2)
    var haveFuel = false
    let spaceDogLabel = SKLabelNode(text: "Trash Items Collected:")
    let numberOfDogsLabel = SKLabelNode(text: "0")
    //level labels
    let level1Label = SKLabelNode(text: "Level 1")
    let level2Label = SKLabelNode(text: "Level 2")
    let level3Label = SKLabelNode(text:"Level 3")
    //score labels
    let numberOutOfLabel = SKLabelNode(text:"Number of Items to Collect:")
    let numberOfItemsLabel = SKLabelNode(text: "0")
    let bestLabel = SKLabelNode(text: "Best Score:")
    let bestScoreLabel = SKLabelNode (text: "0")
    //Instructions labels
    var ruleLabel1 = SKLabelNode(text: "Walk up to the bucket to start")
    var ruleLabel2 = SKLabelNode(text: "Click on the trash to earn points")
    var ruleLabel3 = SKLabelNode(text: "Avoid clicking on the animals")
    var ruleLabel4 = SKLabelNode(text: "If you click on an animal, you go down a level")
    var ruleLabel5 = SKLabelNode(text: "Your score gets higher as you go up levels")
    var gameLogo: SKLabelNode!
    
    var dogCount = 0 {
        didSet {
            self.numberOfDogsLabel.text = "\(dogCount)"
        }
    }
    
    var trashItems = 0 {
        didSet {
            self.numberOfItemsLabel.text = "\(trashItems)"
        }
    }
    
    var bestScore = 0 {
        didSet {
            self.bestScoreLabel.text = "\(bestScore)"
        }
    }
    
    var animalCount = 0
    
    func setUpWorld() {
        trashItems = 3
        levelCount = 1
        level1Label.isHidden = false
        level2Label.isHidden = true
        level3Label.isHidden = true
        // Create anchor using the camera's current position
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "Level1") else {
            return
        }
        for node in scene.children {
            if let node = node as? SKSpriteNode {
            var translation = matrix_identity_float4x4
            let PositionX = node.position.x/scene.size.width
            let PositionY = node.position.y/scene.size.height
            translation.columns.3.x = Float(PositionX*gameSize.width)
            translation.columns.3.z = -Float(PositionY*gameSize.height)
            translation.columns.3.y = Float.random(in: -0.5..<0.5)
            let transform = simd_mul(currentFrame.camera.transform, translation)
                let anchor = Anchor(transform: transform)
                if let name = node.name,
                    let type = NodeType(rawValue: name) {
                    anchor.type = type
                    sceneView.session.add(anchor: anchor)
                }
        }
    }
     isWorldSetUp = true
    }
    
    func setUpWorld2 () {
        trashItems = 4
        levelCount = 2
        level1Label.isHidden = true
        level2Label.isHidden = false
        level3Label.isHidden = true
        haveFuel = false
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "Level2") else {
                return
        }
        for node in scene.children {
            if let node = node as? SKSpriteNode {
                var translation = matrix_identity_float4x4
                let PositionX = node.position.x/scene.size.width
                let PositionY = node.position.y/scene.size.height
                translation.columns.3.x = Float(PositionX*gameSize.width)
                translation.columns.3.z = -Float(PositionY*gameSize.height)
                translation.columns.3.y = Float.random(in: -0.5..<0.5)
                let transform = simd_mul(currentFrame.camera.transform, translation)
                let anchor = Anchor(transform: transform)
                if let name = node.name,
                    let type = NodeType(rawValue: name) {
                    anchor.type = type
                    sceneView.session.add(anchor: anchor)
                }
            }
        }
        isWorld2SetUp = true
    }
    
    func setUpWorld3 () {
        trashItems = 6
        level1Label.isHidden = true
        level2Label.isHidden = true
        level3Label.isHidden = true
        haveFuel = false
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "Level3") else {
                return
        }
        for node in scene.children {
            if let node = node as? SKSpriteNode {
                var translation = matrix_identity_float4x4
                let PositionX = node.position.x/scene.size.width
                let PositionY = node.position.y/scene.size.height
                translation.columns.3.x = Float(PositionX*gameSize.width)
                translation.columns.3.z = -Float(PositionY*gameSize.height)
                translation.columns.3.y = Float.random(in: -0.5..<0.5)
                let transform = simd_mul(currentFrame.camera.transform, translation)
                let anchor = Anchor(transform: transform)
                if let name = node.name,
                    let type = NodeType(rawValue: name) {
                    anchor.type = type
                    sceneView.session.add(anchor: anchor)
                }
            }
        }
        isWorld3SetUp = true
    }
    
    func adjustLightning () {
        guard let currentFrame = sceneView.session.currentFrame, let lightEstimate = currentFrame.lightEstimate else {
            return
        }
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        for node in children {
            if let spaceDog = node as? SKSpriteNode {
                spaceDog.color = .black
                spaceDog.colorBlendFactor = blendFactor
            }
        }
    }
    
    func rescueDog () {
        let location = aim.position
        let hitNodes = nodes(at: location)
        var rescuedDog: SKNode?
        for node in hitNodes {
            if (node.name == "trapped dog" || node.name == "plastic bottle" || node.name == "fishing net" ) && haveFuel == true {
                rescuedDog = node
                break
            }
        }
        if let rescuedDog = rescuedDog {
            let wait = SKAction.wait(forDuration: 0.2)
            let removeDog = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, removeDog])
            rescuedDog.run(sequence)
            dogCount+=1
        }
        
    }
    
    func collectFuel (currentFrame: ARFrame) {
        for anchor in currentFrame.anchors {
            guard let node = sceneView.node(for: anchor),
                node.name == NodeType.fuel.rawValue
                else {continue}
            let distance = simd_distance(anchor.transform.columns.3, currentFrame.camera.transform.columns.3)
            if distance < 0.1 {
                sceneView.session.remove(anchor: anchor)
                haveFuel = true
                break
            }
        }
    }
    
    func collectAnimal () {
        let location = aim.position
        let hitNodes = nodes(at: location)
        var rescuedDog: SKNode?
        for node in hitNodes {
            if node.name == "fish" || node.name == "starfish" {
                rescuedDog = node
                break
            }
        }
        if let rescuedDog = rescuedDog {
            let wait = SKAction.wait(forDuration: 0.2)
            let removeDog = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, removeDog])
            rescuedDog.run(sequence)
            animalCount += 1
            goDownLevel()
        }
        
    }
    
    func goDownLevel () {
        haveFuel = false
        if animalCount == 1 && isWorld2SetUp == true {
        let scene = SKScene(fileNamed: "Level2")
            for node in scene!.children {
                node.removeFromParent()
            }
            dogCount = 0
            animalCount = 0
            isWorld2SetUp = false
            isWorldSetUp = false
        } else if animalCount == 1 && isWorldSetUp == true {
            let scene = SKScene(fileNamed: "Level1")
            for node in scene!.children {
                node.removeFromParent()
            }
            dogCount = 0
            animalCount = 0
            isWorldSetUp = false
        }
    }
    
    func setUpLabels () {
        //level labels
        level1Label.fontSize = 20
        level1Label.fontName = "ArialRoundedMTBold-Bold"
        level1Label.color = .white
        level1Label.position = CGPoint(x: 0, y: 320)
        addChild(level1Label)
        level2Label.fontSize = 20
        level2Label.fontName = "ArialRoundedMTBold-Bold"
        level2Label.color = .white
        level2Label.position = CGPoint(x: 0, y: 320)
        addChild(level2Label)
        //score labels
        spaceDogLabel.fontSize = 20
        spaceDogLabel.fontName = "ArialRoundedMTBold"
        spaceDogLabel.color = .white
        spaceDogLabel.position = CGPoint(x: 0, y: 270)
        addChild(spaceDogLabel)
        numberOfDogsLabel.fontSize = 20
        numberOfDogsLabel.fontName = "ArialRoundedMTBold"
        numberOfDogsLabel.color = .white
        numberOfDogsLabel.position = CGPoint(x: 120, y: 269)
        addChild(numberOfDogsLabel)
        //rule labels
        ruleLabel1.fontSize = 16
        ruleLabel1.fontName = "ArialRoundedMTBold"
        ruleLabel1.color = .white
        ruleLabel1.position = CGPoint(x: 0, y: 140)
        addChild(ruleLabel1)
        ruleLabel2.fontSize = 16
        ruleLabel2.fontName = "ArialRoundedMTBold"
        ruleLabel2.color = .white
        ruleLabel2.position = CGPoint(x: 0, y: 120)
        addChild(ruleLabel2)
        ruleLabel3.fontSize = 16
        ruleLabel3.fontName = "ArialRoundedMTBold"
        ruleLabel3.color = .white
        ruleLabel3.position = CGPoint(x: 0, y: 100)
        addChild(ruleLabel3)
        ruleLabel4.fontSize = 16
        ruleLabel4.fontName = "ArialRoundedMTBold"
        ruleLabel4.color = .white
        ruleLabel4.position = CGPoint(x: 0, y: 80)
        addChild(ruleLabel4)
        ruleLabel5.fontSize = 16
        ruleLabel5.fontName = "ArialRoundedMTBold"
        ruleLabel5.color = .white
        ruleLabel5.position = CGPoint(x: 0, y: 60)
        addChild(ruleLabel5)
        numberOutOfLabel.fontSize = 16
        numberOutOfLabel.fontName = "ArialRoundedMTBold"
        numberOutOfLabel.color = .white
        numberOutOfLabel.position = CGPoint(x: 0, y: 295)
        addChild(numberOutOfLabel)
        numberOfItemsLabel.fontSize = 16
        numberOfItemsLabel.fontName = "ArialRoundedMTBold"
        numberOfItemsLabel.color = .white
        numberOfItemsLabel.position = CGPoint(x: 115, y: 295)
        addChild(numberOfItemsLabel)
        bestLabel.fontSize = 16
        bestLabel.fontName = "ArialRoundedMTBold"
        bestLabel.color = .black
        bestLabel.position = CGPoint(x: -135, y: 340)
        addChild(bestLabel)
        bestScoreLabel.fontSize = 16
        bestScoreLabel.fontName = "ArialRoundedMTBold"
        bestScoreLabel.color = .black
        bestScoreLabel.position = CGPoint(x: -85, y: 340)
        addChild(bestScoreLabel)
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: frame.midX, y: frame.midY-275)
        gameLogo.fontSize = 50
        gameLogo.text = "Ocean Pickup"
        gameLogo.fontColor = SKColor.cyan
        self.addChild(gameLogo)
    }
    
    func scorePlacement () {
        gameLogo.run(SKAction.move(by: CGVector(dx: frame.midX, dy: frame.midY-150), duration: 0.9)) {
            self.gameLogo.isHidden = true
        }
    }
    
    func rulesLabels () {
        let delayInSeconds = 0.3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
        self.ruleLabel1.run(SKAction.scale(to: 0, duration: 0.5))
            self.ruleLabel1.isHidden = true
        self.ruleLabel2.run(SKAction.scale(to: 0, duration: 0.5))
            self.ruleLabel2.isHidden = true
        self.ruleLabel3.run(SKAction.scale(to: 0, duration: 0.5))
            self.ruleLabel3.isHidden = true
        self.ruleLabel4.run(SKAction.scale(to: 0, duration: 0.5))
            self.ruleLabel4.isHidden = true
        self.ruleLabel5.run(SKAction.scale(to: 0, duration: 0.5))
            self.ruleLabel5.isHidden = true
        }
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        aim = SKSpriteNode(imageNamed: "aim")
        addChild(aim)
        background = SKSpriteNode(imageNamed: "water")
        background.zPosition = -50
        addChild(background)
        setUpLabels()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isWorldSetUp == false && dogCount == 0 {
            if dogCount > bestScore {
                bestScore = dogCount
            }
            setUpWorld()
        }
        if dogCount == 3 && isWorld2SetUp == false {
            if dogCount > bestScore {
                bestScore = dogCount
            }
            isWorldSetUp = false
            setUpWorld2()
            //spaceDogLabel.isHidden = true
            //numberOfDogsLabel.isHidden = true
        }
        if dogCount == 7 && isWorldSetUp == false {
            if dogCount > bestScore {
                bestScore = dogCount
            }
            isWorld2SetUp = false
            setUpWorld3()
        }
        adjustLightning()
        guard let currentFrame = sceneView.session.currentFrame  else {
            return
        }
        collectFuel(currentFrame:currentFrame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rescueDog()
        collectAnimal()
        rulesLabels()
        scorePlacement()
        
        //goDownLevel()
    }
    
    var sceneOne:SKScene?
    var sceneTwo:SCNScene?
    
    
    //if let scene = SKScene(fileNamed: "Extended3DLevels") as! SceneTwo?
//    func viewDidAppear(_ animated: Bool) {
//
//        if dogCount == 7 {
//            func presentScene(_sceneTwo: SCNScene) {
//
//            }
//        }
//    }
    
    
    
//    func test () {
//    let levelThree = UIViewController()
//    }
//    
//    if dogCount == 7 {
//        func viewDidAppear(_ animated: Bool) {
//        let storyboard: UIViewController = UIStoryboard(name: "Extended3DLevels", bundle: nil)
//        }
//    }
//    
//    func test () {
//        let levelThree = UIViewController(coder: "Extended3DLevels") as! Extended3DLevels
//    }
//}
}

