//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Ignacio Cervino on 23/02/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {

        setUpStaticUI()



    }

    private func setUpStaticUI() {
        backgroundColor = .cyan

        let background = SKSpriteNode(imageNamed: "curtains")
        background.position = CGPoint(x: 512, y: 384)
        background.size = view!.bounds.size
        background.zPosition = -1
        addChild(background)

        var rowYPosition = 590
        for _ in 0 ..< 3 {
            let rows = SKSpriteNode(imageNamed: "shelf")
            rows.position = CGPoint(x: 512, y: rowYPosition)
            rows.size.width = background.size.width
            rows.zPosition = -2
            addChild(rows)

            rowYPosition -= 140
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
