//
//  GameScene.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var bg:Background
    var player:Player

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
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if location.y < CGRectGetMaxY(player.frame) {
                continue
            }

            player.lookAt(location)
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let laser = SKSpriteNode(imageNamed: "laserGreen.png")
            
            player.lookAt(location)
            switch player.lastFired {
            case .Left:
                laser.position = CGPoint(x: CGRectGetMaxX(player.frame), y: CGRectGetMidY(player.frame))
                player.lastFired = .Right
            case .Right:
                laser.position = CGPoint(x: CGRectGetMinX(player.frame), y: CGRectGetMidY(player.frame))
                player.lastFired = .Left
            }
            laser.lookAt(location)
            laser.runAction(SKAction.moveTo(location, duration: 0.66), completion:{
                self.removeChildrenInArray([laser])
                })
            self.addChild(laser)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bg.update(currentTime)
    }
}
