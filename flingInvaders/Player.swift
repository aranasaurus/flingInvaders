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
    var lasers:[Laser]

    init() {
        lastFired = .Right
        lasers = [
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png")
        ]
        let tx = SKTexture(imageNamed: "player.png")
        super.init(texture: tx, color: UIColor.clearColor(), size: tx.size())
    }

    func fireAt(targetLoc:CGPoint, velocity:CGPoint) {
        var laser = self.lasers[0] // temporarily store a value in 'laser'
        var foundInactive = false
        for l in self.lasers {
            if !l.active {
                laser = l
                foundInactive = true
                break
            }
        }
        if !foundInactive {
            // TODO: make a *click* sound or something
            NSLog("no lasers available")
            return
        }

        laser.velocity = velocity
        laser.active = true
        switch self.lastFired {
        case .Left:
            laser.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame))
            self.lastFired = .Right
        case .Right:
            laser.position = CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMidY(self.frame))
            self.lastFired = .Left
        }
        let targetLoc = CGPoint(x: laser.position.x + (laser.velocity.x*3), y: laser.position.y + (laser.velocity.y*3))
        laser.lookAt(targetLoc)
        self.lookAt(targetLoc)
        self.scene.addChild(laser)
    }

    func update(deltaTime:NSTimeInterval) {
        for laser in self.lasers {
            if !laser.active {
                continue
            }

            laser.update(deltaTime)

            if laser.position.y > self.scene.frame.size.height {
                laser.removeFromParent()
                laser.active = false
            }
        }
    }
}