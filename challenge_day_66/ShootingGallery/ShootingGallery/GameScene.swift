//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Ignacio Cervino on 23/02/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var cursor: SKSpriteNode!
    var possibleTargets = ["target1", "target2", "target3"]

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {

        setUpStaticUI()



    }

    private func setUpStaticUI() {
        cursor = SKSpriteNode(imageNamed: "cursor")
        cursor.position = CGPoint(x: 512, y: 384)
        cursor.physicsBody = SKPhysicsBody(texture: cursor.texture!, size: cursor.size)
        cursor.physicsBody?.contactTestBitMask = 1
        addChild(cursor)

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

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero // Don't want gravity
        physicsWorld.contactDelegate = self // tell us when contact happens
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        cursor.position = location
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
