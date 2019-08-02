//
//  HomeViewController.swift
//  Splash
//
//  Created by GWC2 on 8/2/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var earthImage: UIImageView!
    
    let earthArray = [UIImage(named: "`1"), UIImage(named: "`2"), UIImage(named: "`3"), UIImage(named: "`4"), UIImage(named: "`5"), UIImage(named: "`6"), UIImage(named: "`7"), UIImage(named: "`8"), UIImage(named: "`9"), UIImage(named: "`10"), UIImage(named: "`11"), UIImage(named: "`12"), UIImage(named: "`13"), UIImage(named: "`14"), UIImage(named: "`15"), UIImage(named: "`16"), UIImage(named: "`17"), UIImage(named: "`18"), UIImage(named: "`19"), UIImage(named: "`20"), UIImage(named: "`21"), UIImage(named: "`22"), UIImage(named: "`23"),UIImage(named: "`1"), UIImage(named: "`2"), UIImage(named: "`3"), UIImage(named: "`4"), UIImage(named: "`5"), UIImage(named: "`6"), UIImage(named: "`7"), UIImage(named: "`8"), UIImage(named: "`9"), UIImage(named: "`10"), UIImage(named: "`11"), UIImage(named: "`12"), UIImage(named: "`13"), UIImage(named: "`14"), UIImage(named: "`15"), UIImage(named: "`16"), UIImage(named: "`17"), UIImage(named: "`18"), UIImage(named: "`19"), UIImage(named: "`20"), UIImage(named: "`21"), UIImage(named: "`22"), UIImage(named: "`23") ]
    var earthTimer: Timer?
    var globeSpinning = true
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        spinEarth()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spinEarth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func spinEarth() {
        var delay: Double = 0
        for i in 0...45 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                let image = self.earthArray[i]
                self.earthImage.image = image
            })
            
            delay += 0.21
        }
    }


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

