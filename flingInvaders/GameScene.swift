//
//  GameScene.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

enum ColliderType: UInt32 {
    case Ship = 1
    case Meteor = 2
    case Laser = 4
    case Wall = 8
}

extension SKSpriteNode {
    func lookAt(location: CGPoint) {
        let dx = location.x - self.position.x
        let dy = location.y - self.position.y
        self.zRotation = atan2(dy, dx) - M_PI_2
    }
}

func randFloat(min:CGFloat, max:CGFloat) -> CGFloat {
    return (CGFloat(arc4random())/0x100000000) * (max-min) + min
}

func randPoint(bounds:CGRect) -> CGPoint {
    return CGPoint(x: randFloat(CGRectGetMinX(bounds), CGRectGetMaxX(bounds)),
        y: randFloat(CGRectGetMinY(bounds), CGRectGetMaxY(bounds)))
}

func randVector(min:CGFloat, max:CGFloat) -> CGVector {
    return CGVectorMake(randFloat(min, max), randFloat(min, max))
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var lastTime = NSDate().timeIntervalSinceReferenceDate
    var bg:Background
    var player:Player
    var unlocked = false
    var flingBegan = CGPointZero
    var meteors = [Meteor]()

    init(coder aDecoder: NSCoder!) {
        bg = Background()
        player = Player()
        super.init(coder: aDecoder)
    }
    init(size: CGSize) {
        bg = Background()
        player = Player()
        super.init(size: size)
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()

        bg.zPosition = 0
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)

        player.zPosition = 10
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:player.size.height + 10)
        self.addChild(player)

        var flingRecognizer = UIPanGestureRecognizer(target: self, action:"fling:")
        self.view.addGestureRecognizer(flingRecognizer)

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        let walls = SKPhysicsBody(edgeLoopFromRect: self.frame)
        walls.friction = 0
        walls.categoryBitMask = ColliderType.Wall.toRaw()
        self.physicsBody = walls

        for _ in 1...4 {
            var meteor = Meteor(bounds: self.frame)
            self.addChild(meteor)
            meteor.activate()
        }
    }

    func fling(recognizer:UIPanGestureRecognizer) {
        let touchLocation = self.convertPointFromView(recognizer.locationInView(recognizer.view))
        let touchVelocity = recognizer.velocityInView(self.view)
        let mag = fabs(touchVelocity.x) + fabs(touchVelocity.y)

        switch recognizer.state {
        case .Began:
            self.flingBegan = touchLocation
        case .Ended:
            // don't fire when velocity is too low
            if mag < 650 {
                break
            }
            player.fire(self.flingBegan, targetLoc: touchLocation, touchVelocity: touchVelocity)
            unlocked = false
            self.flingBegan = CGPointZero
        case .Cancelled, .Failed:
            unlocked = false
        case .Changed:
            if touchLocation.y > CGRectGetMaxY(self.frame) * 0.4 || mag < 300 {
                unlocked = true
            }

            if unlocked {
                player.lookAt(touchLocation)
            }
        default:
            break
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            self.player.lookAt(touchLocation)
            let m = Meteor(position: touchLocation, meteorType: .Big)
            self.addChild(m)
            m.activate()
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bg.update(currentTime)
        player.update(currentTime - self.lastTime)
        self.lastTime = currentTime
    }

    func didBeginContact(contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask {
        case ColliderType.Meteor.toRaw():
            if contact.bodyB.categoryBitMask == ColliderType.Laser.toRaw() {
                (contact.bodyA.node as Meteor).hit()
                contact.bodyB.node.removeFromParent()
                contact.bodyB.categoryBitMask = 0
            }
        case ColliderType.Laser.toRaw():
            if contact.bodyB.categoryBitMask == ColliderType.Meteor.toRaw() {
                (contact.bodyB.node as Meteor).hit()
                contact.bodyA.node.removeFromParent()
                contact.bodyA.categoryBitMask = 0
            }
        default:
            break
        }
    }
}
