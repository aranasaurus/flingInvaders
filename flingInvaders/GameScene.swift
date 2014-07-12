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

    init(coder aDecoder: NSCoder!) {
        bg = Background()
        super.init(coder: aDecoder)
    }
    init(size: CGSize) {
        bg = Background()
        super.init(size: size)
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()

        bg.zPosition = 0
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        myLabel.zPosition = 1
        self.addChild(myLabel)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"player.png")
            
            sprite.xScale = 1
            sprite.yScale = 1
            sprite.position = location
            sprite.zPosition = 2
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bg.update(currentTime)
    }
}
