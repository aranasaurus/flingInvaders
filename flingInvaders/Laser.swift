//
//  Laser.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/13/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class Laser: SKSpriteNode {
    var velocity: CGPoint
    var active = false

    init(velocity:CGPoint, imageNamed:String) {
        self.velocity = velocity
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }

    func update(updateTime:NSTimeInterval) {
        //NSLog("update: \(updateTime)")
        //NSLog("update: \(velocity.x * updateTime), \(velocity.y * updateTime)")
        self.position = CGPoint(x: position.x + (velocity.x * updateTime), y: position.y + (velocity.y * updateTime))
    }
}
