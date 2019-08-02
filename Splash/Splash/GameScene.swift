//
//  GameScene.swift
//  Capstone Scroll Game Test
//
//  Created by GWC2 on 7/30/19.
//  Copyright © 2019 GWC2. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bubble:SKEmitterNode!
    var player: SKSpriteNode!
    var bestScore: SKLabelNode!
    var currentScores: SKLabelNode!
    var currentScore: Int = 0
    var soundEffectTest: AVAudioPlayer?
    //var scoreLabel: SKLabelNode!
    //var highScoreLabel: SKLabelNode!
    /*var score = 0 {
        didSet{
            scoreLabel.text = "SCORE: \(score)"
        }
    }*/
    /*var highScore = 0 {
        didSet{
            scoreLabel.text = "HIGH SCORE: \(highScore)"
        }
    }*/
    var lastScoreUpdateTime: TimeInterval = 0.0
    var isPlaying: Bool = false
    //var logo: SKSpriteNode!
    var gameLogo: SKLabelNode!
    /*
    var factLabel: SKLabelNode!
    var oceanFacts: SKLabelNode!
    
    
    let factNumber: Int = Int.random(in: 0...13)
    let factList: [String] = ["1 in 3 species of marine mammals have been found entangled in marine litter.",
            "The Great Pacific Garbage Patch has more than 1.9 million bits of plastic per square mile.",
            "Every year, 8 million metric tons of plastic end up in our oceans.",
            "There are around 5.25 trillion pieces of plastic debris in the ocean.",
            "Around the globe, a million plastic bags are used a minute.",
            "The #1 man-made thing that sailors see in our oceans are plastic bags.",
            "It takes just 4 family shopping trips to accumulate 60 shopping bags.",
            "World wide, 13,000-15,000 pieces of plastic are dumped into the ocean every day.",
            "Scientists have identified 200 areas declared as ‘dead zones’ where no life organisms can now grow.",
            "In areas like the North Pacific Central Gyre, the mass of plastic is up to six times greater than the mass of plankton.",
            "Plastics do not biodegrade, but instead break down into small, toxic particles that enter the food chain through marine life.",
            "Plastic bags, which resemble jellyfish, are the most commonly found synthetic item in sea turtles’ stomachs.",
            "Researchers found that 80 percent of seabird species that spend most of their time at sea have plastic in their stomachs. This means that they are likely feeding their chicks plastic.",
            "It is estimated that plastic marine debris has reduced the value of marine ecosystem services by $500–$2500 billion each year."]
    
    var factTimer: Timer?
    
    @objc func setFact() {
        
        guard let fact = factList.randomElement() else { return }
        factLabel.text = fact
        self.oceanFacts.isHidden = false
        self.factLabel.isHidden = false
    }
    */
    private func initializeMenu() {
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: frame.midX, y: frame.midY+300)
        gameLogo.fontSize = 60
        gameLogo.text = "Flappy Fish"
        gameLogo.fontColor = SKColor.cyan
        self.addChild(gameLogo)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: frame.midX, y: gameLogo.position.y - 50)
        bestScore.fontSize = 30
        bestScore.text = "Best Score: 00"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        
        //factTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setFact), userInfo: nil, repeats: true)
        
        /*
        let button = UIButton(frame: CGRect(x: frame.midX-50, y: frame.midY+250, width: 70, height: 50))
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
        button.setTitle("Home", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view!.addSubview(button)
        */
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    //@objc func buttonAction(sender: UIButton!) {
    //    print("Button tapped")
    //}
    
    //3
    private func initializeGameView() {
        //4
        currentScores = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScores.zPosition = 1
        currentScores.position = CGPoint(x: frame.midX, y: frame.midY+300)
        currentScores.fontSize = 30
        currentScores.isHidden = true
        currentScores.text = "Score: 0"
        currentScores.fontColor = SKColor.white
        self.addChild(currentScores)
    }
    
    private func updateHScore() {
        if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currentScore, forKey: "bestScore")
        }
        currentScore = 0
        currentScores.text = "Score: 0"
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        self.oceanFacts.run(SKAction.scale(to: 0, duration: 0.5))
        self.oceanFacts.isHidden = true
        self.factLabel.run(SKAction.scale(to: 0, duration: 0.5))
        self.factLabel.isHidden = true
        */
        playSound()
        if isPlaying == false {
            startNets()
            scorePlacement ()
            isPlaying = true
            player.physicsBody?.isDynamic = true
            
        } else {
            
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 25))
        }
        /*
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([fadeOut, remove, wait])
        logo.run(sequence)
        
        let hFadeOut = SKAction.fadeOut(withDuration: 0.5)
        let hRemove = SKAction.removeFromParent()
        let hWait = SKAction.wait(forDuration: 0.5)
        let hSequence = SKAction.sequence([hFadeOut, hRemove, hWait])
        highScoreLabel.run(hSequence)*/
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       player.removeFromParent()
        isPlaying = false
        speed = 0
        
        restartGame()
        updateHScore()
        currentScores.run(SKAction.scale(to: 0, duration: 0.4))
        self.currentScores.isHidden = true
        self.bestScore.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY+450), duration: 0.3))
        
        let deadTexture = SKTexture(imageNamed: "dead")
        let dead = SKSpriteNode(texture: deadTexture)
        dead.position = player.position
        addChild(dead)
    }
    
    
    func createPlayer () {
        let playerTexture = SKTexture(imageNamed: "dolphin")
        //dolphin photo credit to MF99K on Deviant Art
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width/4, y: frame.height*0.70)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        
        let frame2 = SKTexture(imageNamed: "dolphin1")
        let frame3 = SKTexture(imageNamed: "dolphin2")
        let frame4 = SKTexture(imageNamed: "dolphin3")
        let frame5 = SKTexture(imageNamed: "dolphin4")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame4, frame5], timePerFrame: 0.1)
        //let sound = SKAction.playSoundFileNamed("sound effect", waitForCompletion: false)
        let runForever = SKAction.repeatForever((animation))
        
        player.run(runForever)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isPlaying == true {
            updateScore(withCurrentTime: currentTime)

        }
    }
    
    func createBackground () {
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0...1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
            
        }
        
    }
    
    func createGround () {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0...1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width/2.0 + (groundTexture.size().width*CGFloat(i))), y: groundTexture.size().height/2)
            
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
            
        }
    }
    
    func createNets () {
        let netTexture = SKTexture(imageNamed: "net")
        
        let topNet = SKSpriteNode(texture: netTexture)
        topNet.physicsBody = SKPhysicsBody(texture: netTexture, size: netTexture.size())
        topNet.physicsBody?.isDynamic = false
        topNet.zPosition = -20
        
        let bottomNet = SKSpriteNode(texture: netTexture)
        bottomNet.physicsBody = SKPhysicsBody(texture: netTexture, size: netTexture.size())
        bottomNet.physicsBody?.isDynamic = false
        bottomNet.zPosition = -20
        
        addChild(topNet)
        addChild(bottomNet)
        
        let xPosition = frame.width + topNet.frame.width
        let max = CGFloat (frame.height/3)
        let yPosition = CGFloat.random(in: -50...max)
        let netDistance: CGFloat = 70
        
        topNet.position = CGPoint(x: xPosition, y: yPosition + topNet.size.height*1.5 + netDistance)
        bottomNet.position = CGPoint(x: xPosition, y: yPosition)
        
        let endPosition = frame.width+(topNet.frame.width*2)
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        topNet.run(moveSequence)
        bottomNet.run(moveSequence)
    }
    
    func startNets () {
        let create = SKAction.run { [unowned self] in
            self.createNets()
        }
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create,wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    /*
    func createScore () {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY+380)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.white
        addChild(scoreLabel)
    }
    */
    func updateScore(withCurrentTime currentTime:TimeInterval){
        let elapsedTime = currentTime - lastScoreUpdateTime
        if elapsedTime > 1.0 {
            currentScore += 1
            lastScoreUpdateTime = currentTime
            currentScores.text = "Score: \(currentScore)"
        }
    }
    
    func restartGame(){
        /*
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOver = SKScene(fileNamed: "GameOver") as! GameOver
        gameOver.score = self.score
        self.view?.presentScene(gameOver, transition: transition)
        */
        let scene = GameScene(fileNamed: "GameScene")!
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2)
        self.view?.presentScene(scene, transition: transition)
    }
    /*
    func createLogo(){
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
    }
    
    func highScorefunc () {
        
        highScoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        highScoreLabel.fontSize = 24
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY+330)
        highScoreLabel.text = "HIGH SCORE: \(highScore)"
        highScoreLabel.fontColor = UIColor.white
        addChild(highScoreLabel)
        
    }
    
    func updateHighScore (){
        if highScore < score {
            highScoreLabel.text = "HIGH SCORE: \(3)"
            //score resets to 0
        }
    }
    */
    
    func scorePlacement () {
        gameLogo.run(SKAction.move(by: CGVector(dx: frame.midX, dy: frame.midY+150), duration: 0.9)) {
            self.gameLogo.isHidden = true
        }
        //2
        let bottomCorner = CGPoint(x: frame.midX, y: frame.midY-500)
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.9))
        initializeGameView()
        
        //button.frame = CGRect(x: frame.midX-20, y: frame.midY+300, width: 0, height: 0, duration: 0.5)

        self.currentScores.setScale(0)
        self.currentScores.isHidden = false
        self.currentScores.run(SKAction.scale(to: 1, duration: 0.5))
    }
    
    func sound () {
    var backgroundMusic: SKAudioNode!
    if let musicURL = Bundle.main.url(forResource: "Marvin_s_Dance", withExtension: "mp3") {
        backgroundMusic = SKAudioNode(url: musicURL)
        addChild(backgroundMusic)
        print("success!")
    } else {
    print("could not load file :(")
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "soundeffect", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            soundEffectTest = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let play = soundEffectTest else { return }
            
            play.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func didMove(to view: SKView) {
        
        createPlayer ()
        createBackground ()
        createGround ()
        sound ()
        //createScore()
        //createLogo()
        //highScorefunc()
        //updateHighScore()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)
        bubble = (self.childNode(withName: "bubble") as! SKEmitterNode)
        bubble.advanceSimulationTime(5)
        
        initializeMenu()
        
    }
    
    
}

