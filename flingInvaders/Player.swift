//
//  Player.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

enum LaserSide {
    case Right, Left
}

extension SKSpriteNode {
    func lookAt(location: CGPoint) {
        let dx = location.x - self.position.x
        let dy = location.y - self.position.y
        self.zRotation = atan2(dy, dx) - M_PI_2
    }
}

class Player:SKSpriteNode {

    var lastFired: LaserSide

    init() {
        lastFired = .Right
        let tx = SKTexture(imageNamed: "player.png")
        super.init(texture: tx, color: UIColor.clearColor(), size: tx.size())
    }
}