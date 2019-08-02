//
//  GameViewController.swift
//  Capstone Scroll Game Test
//
//  Created by GWC2 on 7/30/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
    self.alpha = 1.0
        }, completion: completion)  }
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
    self.alpha = 0.0
        }, completion: completion)
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var oceanFacts: UILabel!
    
    let factNumber: Int = Int.random(in: 0...13)
    let factList: [String] = ["1 in 3 species of marine mammals have been found entangled in marine litter.",
        "The Great Pacific Garbage Patch has more than 1.9 million bits of plastic per square mile.",
            "Every year, 8 million metric tons of plastic end up in our oceans.",
            "There are around 5.25 trillion pieces of plastic debris in the ocean.",
            "Around the globe, a million plastic bags are used a minute.",
        "The #1 man-made thing that sailors see in our oceans are plastic bags.",
        "It takes just 4 family shopping trips to accumulate 60 shopping bags.",
        "World wide, 13,000-15,000 pieces of plastic are dumped into the ocean every day.",
        "Scientists have identified 200 areas declared as ‘dead zones’ where no life organisms can now grow.",
        "In areas like the North Pacific Central Gyre, the mass of plastic is up to six times greater than the mass of plankton.",
        "Plastics do not biodegrade, but instead break down into small, toxic particles that enter the food chain through marine life.",
        "Plastic bags, which resemble jellyfish, are the most commonly found synthetic item in sea turtles’ stomachs.",
        "Researchers found that 80 percent of seabird species that spend most of their time at sea have plastic in their stomachs. This means that they are likely feeding their chicks plastic.",
        "It is estimated that plastic marine debris has reduced the value of marine ecosystem services by $500–$2500 billion each year."]
    
    var factTimer: Timer?

    @objc func setFact() {
        
        guard let fact = factList.randomElement() else { return }
        factLabel.text = fact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oceanFacts.isHidden = false
        self.factLabel.isHidden = false
        
        factTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setFact), userInfo: nil, repeats: true)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            //view.showsPhysics = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        self.oceanFacts.isHidden = true
        self.factLabel.isHidden = true
        
    factLabel.fadeOut(completion: {
        (finished: Bool) -> Void in            self.factLabel.isHidden = true
        })
        
    oceanFacts.fadeOut(completion: {
        (finished: Bool) -> Void in       self.oceanFacts.isHidden = true
        })
    
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
