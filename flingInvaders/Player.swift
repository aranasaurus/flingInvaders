//
//  Player.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class Player:SKSpriteNode {

    var lasers:[Laser]

    init() {
        lasers = [
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png"),
            Laser(velocity: CGPointZero, imageNamed: "laserGreen.png")
        ]
        let tx = SKTexture(imageNamed: "player.png")
        super.init(texture: tx, color: UIColor.clearColor(), size: tx.size())
        self.xScale = 0.66
        self.yScale = 0.66
    }

    func fire(sourceLoc:CGPoint, targetLoc:CGPoint, touchVelocity:CGPoint) {
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

        laser.configurePhysicsBody()
        let damper = 0.33
        let velocity = CGPoint(x:touchVelocity.x * damper, y:-touchVelocity.y * damper)
        laser.velocity = velocity
        laser.active = true

        let shot = SKSpriteNode(imageNamed: "laserGreenShot.png")
        shot.xScale = 0.16
        shot.yScale = 0.16
        shot.zPosition = self.zPosition + 1
        self.addChild(shot)

        // Fire from left/right/center of ship based on where the fling began
        let center = CGRectGetMidX(self.scene.frame)
        let fudge = self.size.width/2
        if sourceLoc.x <= center - fudge {
            laser.position = CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMidY(self.frame))
            shot.position = CGPoint(x: -self.frame.width/2 - 8, y: 16)
        } else if sourceLoc.x >= center + fudge {
            laser.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame))
            shot.position = CGPoint(x: self.frame.width/2 + 8, y: 16)
        } else {
            laser.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            shot.position = CGPoint(x: 0, y: self.frame.height/2 + 14)
        }

        // move target ahead 1 second at a time until it is offscreen
        var targetLoc = CGPoint(x: laser.position.x + laser.velocity.x, y: laser.position.y + laser.velocity.y)
        while targetLoc.y < CGRectGetMaxY(self.scene.frame) {
            targetLoc = CGPoint(x: targetLoc.x + laser.velocity.x, y: targetLoc.y + laser.velocity.y)
        }
        laser.lookAt(targetLoc)
        self.lookAt(targetLoc)
        self.scene.addChild(laser)

        let dur = 0.22
        let group = SKAction.group([
            SKAction.fadeOutWithDuration(dur),
            SKAction.scaleTo(1, duration: dur)
            ])
        shot.runAction(group, completion: { shot.removeFromParent() })
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