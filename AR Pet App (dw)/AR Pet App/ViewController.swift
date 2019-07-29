//
//  ViewController.swift
//  AR Pet App
//
//  Created by GWC2 on 7/24/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    var petNode: SCNNode!
    let petNodeName = "shiba"
    var index = 0
    var petScene: SCNScene!
    var petNodeNameArray: [String] = ["chicken", "cow", "dino", "dog", "duck", "fox", "goat", "horse", "pig", "sheep", "shiba"]
    var petSceneArray: [String] = ["Animals/chicken/chicken.scn", "Animals/cow/cow.scn", "Animals/dino/dino.scn", "Animals/dog/dog.scn", "Animals/duck/duck.scn", "Animals/fox/fox.scn", "Animals/goat/goat.scn", "Animals/horse/horse.scn", "Animals/pig/pig.scn", "Animals/sheep/sheep.scn", "Animals/shiba/shiba.scn"]
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
        if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
            let translation = hitTestResultsWithFeaturePoints.worldTransform.translation
            addPet(x: translation.x, y: translation.y, z: translation.z)
        }
        guard let node = hitTestResults.first?.node else { return }
        node.removeFromParentNode()
    }
    
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
       index += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(config)
        // Do any additional setup after loading the view.
        addPet()
    }
    
    func addPet(x: Float = 0, y: Float = 0, z: Float = -0.2) { //update in Part 5
        if index >= petNodeNameArray.count {
            index = 0
            petScene = SCNScene(named: petSceneArray[index])!
            petNode = petScene.rootNode.childNode(withName: petNodeNameArray[index], recursively: true)
            petNode.scale = SCNVector3(0.1, 0.1, 0.1)
            petNode.position = SCNVector3(x, y, z) //update in Part 5
            sceneView.scene.rootNode.addChildNode(petNode)
        } else {
            petScene = SCNScene(named: petSceneArray[index])!
            petNode = petScene.rootNode.childNode(withName: petNodeNameArray[index], recursively: true)
            petNode.scale = SCNVector3(0.1, 0.1, 0.1)
            petNode.position = SCNVector3(x, y, z) //update in Part 5
            sceneView.scene.rootNode.addChildNode(petNode)
        }
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
