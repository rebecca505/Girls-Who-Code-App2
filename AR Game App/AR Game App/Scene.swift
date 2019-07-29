//
//  Scene.swift
//  AR Game App
//
//  Created by GWC2 on 7/25/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    var isWorldSetUp = false
    var aim: SKSpriteNode!
    let gameSize = CGSize(width: 2, height: 2)
    var haveFuel = false
    let spaceDogLabel = SKLabelNode(text: "Space Dogs Rescued:")
    let numberOfDogsLabel = SKLabelNode(text: "0")
    var dogCount = 0 {
        didSet {
            self.numberOfDogsLabel.text = "\(dogCount)"
        }
    }
    
    func setUpWorld() {
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
            if node.name == "trapped dog" && haveFuel == true {
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
    
    func setUpLabels () {
        spaceDogLabel.fontSize = 20
        spaceDogLabel.fontName = "Futura-Medium"
        spaceDogLabel.color = .white
        spaceDogLabel.position = CGPoint(x: 0, y: 280)
        addChild(spaceDogLabel)
        numberOfDogsLabel.fontSize = 25
        numberOfDogsLabel.fontName = "Futura-Medium"
        numberOfDogsLabel.color = .white
        numberOfDogsLabel.position = CGPoint(x: 0, y: 250)
        addChild(numberOfDogsLabel)
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        aim = SKSpriteNode(imageNamed: "aim")
        addChild(aim)
        setUpLabels()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isWorldSetUp == false {
            setUpWorld()
        }
        adjustLightning()
        guard let currentFrame = sceneView.session.currentFrame  else {
            return
        }
        collectFuel(currentFrame:currentFrame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rescueDog()
    }
}
