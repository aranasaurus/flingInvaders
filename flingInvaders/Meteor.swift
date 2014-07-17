//
//  Meteor.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/13/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

enum MeteorType {
    case Small
    case Big
}

class Meteor: SKSpriteNode {

    var meteorType: MeteorType
    convenience init(bounds:CGRect) {
        self.init(position:randPoint(bounds), meteorType:.Big)
    }
    init(position:CGPoint, meteorType:MeteorType) {
        self.meteorType = meteorType
        let imageNamed = meteorType == .Small ? "meteorSmall.png" : "meteorBig.png"
        let tx = SKTexture(imageNamed: imageNamed)
        super.init(texture: tx, color: UIColor.clearColor(), size: tx.size())
        self.position = position
        self.xScale = 0.66
        self.yScale = 0.66
    }

    func hit() {
        switch self.meteorType {
        case .Small:
            NSLog("+10")
            self.removeFromParent()
        case .Big:
            NSLog("+1")

            let m1 = Meteor(position: self.position, meteorType: .Small)
            self.parent.addChild(m1)
            m1.activate()

            let m2 = Meteor(position: self.position, meteorType: .Small)
            self.parent.addChild(m2)
            m2.activate()

            self.removeFromParent()
        }
    }

    func activate() {
        let pb = SKPhysicsBody(rectangleOfSize: self.calculateAccumulatedFrame().size)
        pb.categoryBitMask = ColliderType.Meteor.toRaw()
        // TODO: determine if texture based physics body shapes are available and use those, then add
        // meteors to the collision bit mask, so that meteors will bump into each other.
        pb.collisionBitMask = ColliderType.Wall.toRaw() //| ColliderType.Meteor.toRaw()
        pb.contactTestBitMask = ColliderType.Laser.toRaw() | ColliderType.Ship.toRaw() | ColliderType.Wall.toRaw()
        pb.friction = 0
        pb.restitution = 1
        pb.linearDamping = 0
        pb.angularDamping = 0
        pb.mass = 20
        if self.meteorType == .Small {
            pb.mass = pb.mass/2
        }
        pb.allowsRotation = true
        self.physicsBody = pb

        switch self.meteorType {
        case .Big:
            pb.applyImpulse(CGVectorMake(randFloat(-120, 120), randFloat(-120, 120)))
            pb.applyAngularImpulse(randFloat(-1.2, 1.2))
        case .Small:
            pb.applyImpulse(CGVectorMake(randFloat(-180, 180), randFloat(-180, 180)))
            pb.applyAngularImpulse(randFloat(-0.3, 0.3))
        }
    }
}
