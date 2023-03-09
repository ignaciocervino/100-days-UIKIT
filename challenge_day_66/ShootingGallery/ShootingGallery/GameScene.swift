//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Ignacio Cervino on 23/02/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bulletsSprite: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var cursor: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var reload: SKSpriteNode!
    var gameTimer: Timer?
    let gameTime = 60.0
    var duckTimer: Timer?
    var duckTime = 1.0

    var possibleTargets = ["target1", "target2", "target3"]

    var targetSpeed = 4.0
    var targetDelay = 0.8
    var targetsCreated = 0

    var isGameOver = false


    var bulletTextures = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3"),
    ]

    var bulletsInClip = 3 {
        didSet {
            bulletsSprite.texture = bulletTextures[bulletsInClip]
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setUpStaticUI()
        createGameTimer()
        startDuckTimer()
    }

    private func setUpStaticUI() {
        cursor = SKSpriteNode(imageNamed: "cursor")
        cursor.position = CGPoint(x: 512, y: 384)
        cursor.physicsBody = SKPhysicsBody(texture: cursor.texture!, size: cursor.size)
        cursor.physicsBody?.contactTestBitMask = 1
        cursor.physicsBody?.categoryBitMask = 1
        cursor.physicsBody?.categoryBitMask = 0
        addChild(cursor)

        backgroundColor = .cyan

        let background = SKSpriteNode(imageNamed: "curtains")
        background.position = CGPoint(x: 512, y: 384)
        background.size = view!.bounds.size
        background.zPosition = -1
        background.physicsBody?.categoryBitMask = 1
        background.physicsBody?.categoryBitMask = 0
        addChild(background)

        var rowYPosition = 590
        for _ in 0 ..< 3 {
            let rows = SKSpriteNode(imageNamed: "shelf")
            rows.position = CGPoint(x: 512, y: rowYPosition)
            rows.size.width = background.size.width
            rows.zPosition = -2
            rows.physicsBody?.categoryBitMask = 1
            rows.physicsBody?.categoryBitMask = 0
            addChild(rows)

            rowYPosition -= 140
        }

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 680, y: 50)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        bulletsSprite = SKSpriteNode(imageNamed: "shots3")
        bulletsSprite.position = CGPoint(x: 170, y: 60)
        bulletsSprite.zPosition = 1
        addChild(bulletsSprite)

        reload = SKSpriteNode(imageNamed: "reload")
        reload.position = CGPoint(x: 260, y: 60)
        reload.size = CGSize(width: 50, height: 50)
        reload.zPosition = 1
        reload.isHidden = true
        reload.name = "reload"
        addChild(reload)

        physicsWorld.gravity = .zero // Don't want gravity
        physicsWorld.contactDelegate = self // tell us when contact happens
    }

    private func levelUp() {
        targetSpeed *= 0.99
        targetDelay *= 0.99
        targetsCreated += 1

        if targetsCreated < 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + targetDelay) { [unowned self] in
//                self.createTarget()
            }
        }
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isGameOver else { return }
        let location = touch.location(in: self)
        let touchedNode = self.nodes(at: location)

        cursor.position = location
        if bulletsInClip <= 0 {
            if touchedNode.contains(reload) {
                reload.run(SKAction.rotate(byAngle: .pi * 2 , duration: 0.5)) { [weak self] in
                    self?.bulletsInClip = 3
                    self?.reload.isHidden = true
                }
                run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
            } else {
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            }
        } else {
            run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))

            for node in touchedNode {
                if possibleTargets.contains(node.name ?? "") {
                    shot(node)
                }
            }
            bulletsInClip -= 1
        }

        if(bulletsInClip == 0) {
            reload.isHidden = false
        }
    }

    private func shot(_ node: SKNode) {
        guard node.name != "" else { return }

        switch node.name {
        case possibleTargets[0]: score += 5
        case possibleTargets[1]: score += 10
        case possibleTargets[2]: score -= 10
        default: break
        }
        if let fireEffect = SKEmitterNode(fileNamed: "FireParticles") {
            fireEffect.position = node.position
            addChild(fireEffect)
        }
        node.removeFromParent()

    }
    
    override func update(_ currentTime: TimeInterval) {
//        createDisplayLink()
        // Called before each frame is rendered
//        gameTimer = CADisplayLink(target: self, selector: #selector(createDuck))
//        gameTimer?.add(to: .current, forMode: .common)

    }



    func createGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: gameTime, target: self, selector: #selector(showGameOver), userInfo: nil, repeats: false)
    }

    @objc private func showGameOver() {
        isGameOver = true
        duckTimer?.invalidate()

        gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.physicsBody = SKPhysicsBody(texture: gameOver.texture!, size: gameOver.size)
        gameOver.physicsBody?.categoryBitMask = 1
        gameOver.physicsBody?.categoryBitMask = 0
        addChild(gameOver)
    }

    func startDuckTimer() {
        duckTimer = Timer.scheduledTimer(timeInterval: duckTime, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
    }

    @objc private func createDuck() {
        guard let duck = possibleTargets.randomElement(), let tableHeight = [580, 440, 300].randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: duck)
        sprite.position = CGPoint(x: 1200, y: tableHeight)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.zPosition = -2
        sprite.name = duck
        addChild(sprite)

        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.categoryBitMask = 0
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    }
}
