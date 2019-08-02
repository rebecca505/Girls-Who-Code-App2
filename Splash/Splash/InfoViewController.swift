//
//  InfoViewController.swift
//  Splash
//
//  Created by GWC2 on 8/1/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBAction func oceanBlueProject(_ sender: Any) { UIApplication.shared.open(URL(string: "https://secure.processdonation.org/Oceanblueproject/Donation.aspx")! as URL, options: [:], completionHandler: nil) }
    
    @IBAction func wwf(_ sender: Any) { UIApplication.shared.open(URL(string: "https://www.worldwildlife.org/initiatives/oceans")! as URL, options: [:], completionHandler: nil) }
    
    @IBAction func oceana(_ sender: Any) { UIApplication.shared.open(URL(string: "https://act.oceana.org/page/45724/donate/1?ea.tracking.id=takeover&utm_campaign=FR&utm_content=20170722SROTakeover&utm_source=Takeover&utm_medium=Website&amount_other=35&page_id=")! as URL, options: [:], completionHandler: nil) }
    
    @IBAction func oceanConservancy(_ sender: Any) { UIApplication.shared.open(URL(string: "https://oceanconservancy.org/")! as URL, options: [:], completionHandler: nil) }

    @IBOutlet weak var howToHelpLabel: UILabel!
    let howToHelpNumber: Int = Int.random(in: 0...11)
    let howToHelpList: [String] = ["Use a water filter to drink water instead of plastic water bottles.",
            "Use a reusable water bottle.",
            "Clean up plastic when you see it.",
            "Clean up after yourself",
            "Recycle plastic properly.",
            "Reuse plastic.",
            "Don’t use single-use plastic.",
            "Participate in (or organize) a beach or river cleanup",
            "Avoid products containing microbeads.",
            "Spread the word about the environment.",
            "Buy in bulk.",
            ]

    var howToHelpTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setRandomHelp()
        howToHelpTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setRandomHelp), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    @objc func setRandomHelp() {
        guard let help = howToHelpList.randomElement() else { return }
        howToHelpLabel.text = help

    }
}
