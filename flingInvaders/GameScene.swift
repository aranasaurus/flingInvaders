//
//  GameScene.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var lastTime = NSDate().timeIntervalSinceReferenceDate
    var bg:Background
    var player:Player
    var unlocked = false

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
    }

    func fling(recognizer:UIPanGestureRecognizer) {
        let touchLocation = self.convertPointFromView(recognizer.locationInView(recognizer.view))
        let touchVelocity = recognizer.velocityInView(self.view)
        let mag = fabs(touchVelocity.x) + fabs(touchVelocity.y)

        switch recognizer.state {
        case .Ended:
            // don't fire when velocity is too low
            if mag < 650 {
                break
            }
            let damper = 0.33
            let velocity = CGPoint(x:touchVelocity.x * damper, y:-touchVelocity.y * damper)
            player.fireAt(touchLocation, velocity: velocity)
            unlocked = false
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

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bg.update(currentTime)
        player.update(currentTime - self.lastTime)
        self.lastTime = currentTime
    }
}
