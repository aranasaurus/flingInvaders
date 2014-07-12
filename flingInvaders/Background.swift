//
//  Background.swift
//  flingInvaders
//
//  Created by Ryan Arana on 7/12/14.
//  Copyright (c) 2014 aranasaurus.com. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    var bg: SKSpriteNode
    var bg2: SKSpriteNode
    let scrollSpeed = 10.0

    init() {
        bg = SKSpriteNode(imageNamed: "bg_1_1.png")
        bg.zPosition = 0
        bg.position = CGPoint(x:0, y:0)
        bg2 = bg.copy() as SKSpriteNode
        bg2.position = CGPoint(x:0, y:bg.size.height)
        super.init()

        self.position = CGPoint(x:bg.size.width/2, y:bg.size.height/2)

        /* Used to debug/see exactly how the scrolling is working.
        let label1 = SKLabelNode(fontNamed:"Chalkduster")
        label1.text = "1"
        label1.fontSize = 120
        label1.position = CGPoint(x: 0.5, y: 0.5)
        label1.zPosition = 1
        bg.addChild(label1)

        let label2 = SKLabelNode(fontNamed:"Chalkduster")
        label2.text = "2"
        label2.fontSize = 120
        label2.position = CGPoint(x:0.5, y:0.5)
        label2.zPosition = 1
        bg2.addChild(label2)
        */

        self.addChild(bg)
        self.addChild(bg2)
    }

    func update(currentTime: NSTimeInterval) {
        bg.position = CGPoint(x: 0, y: bg.position.y - self.scrollSpeed)
        bg2.position = CGPoint(x: 0, y: bg2.position.y - self.scrollSpeed)

        if (bg.position.y <= -bg.size.height) {
            bg.position = CGPoint(x:0, y:bg.position.y+bg.size.height)
            bg2.position = CGPoint(x:0, y:bg.position.y+bg.size.height)
        }
    }
}
