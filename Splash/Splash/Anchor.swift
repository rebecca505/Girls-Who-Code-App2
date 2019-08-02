//
//  Anchor.swift
//  AR Game App
//
//  Created by GWC2 on 7/25/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import ARKit

class Anchor: ARAnchor {
    var type: NodeType?
}

enum NodeType: String {
    case trappedDog = "trapped dog"
    case fuel = "fuel"
    case plasticBottle = "plastic bottle"
    case fish = "fish"
    case starfish = "starfish"
    case fishingNet = "fishing net"
}


