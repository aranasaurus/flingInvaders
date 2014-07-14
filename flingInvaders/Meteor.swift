//
//  Meteor.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/13/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class Meteor: SKNode {

    var movement = SKAction.moveByX(randFloat(-100, 100), y: randFloat(-100, 100), duration: 1)
    var lastReversal = NSDate(timeIntervalSinceNow: -100)
    convenience init(bounds:CGRect) {
        self.init(position:randPoint(bounds))
    }
    init(position:CGPoint) {
        super.init()
        self.position = position
        self.addChunk("meteorBig.png")
        self.runAction(SKAction.repeatActionForever(self.movement), withKey:"movement")
    }

    func hit() {
        if self.children.count == 1 {
            self.removeAllChildren()
            self.addChunk("meteorSmall.png")
            self.addChunk("meteorSmall.png")
        } else {
            self.removeAllChildren()
            self.removeFromParent()
            // TODO: Score some points!
            NSLog("+1")
        }
    }

    func addChunk(imageNamed:NSString) {
        let rots = Double(randFloat(0.05, 1.3))
        let rotAction = SKAction.rotateByAngle(M_PI * rots, duration: 1)
        let chunk = SKSpriteNode(imageNamed: imageNamed)
        chunk.runAction(SKAction.repeatActionForever(rotAction))
        self.addChild(chunk)
    }

    func update(deltaTime:NSTimeInterval) {
        if (self.lastReversal.timeIntervalSinceNow > -5) {
            return
        }
        if !self.parent.frame.contains(self.calculateAccumulatedFrame()) {
            self.movement = self.movement.reversedAction()
            self.runAction(SKAction.repeatActionForever(self.movement), withKey:"movement")
            self.lastReversal = NSDate()
        }
    }
}
