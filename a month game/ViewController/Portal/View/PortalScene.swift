//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    var viewController: PortalViewController { self.view!.next as! PortalViewController }

    var uiLayer: SKNode!
    var resetWindow: ResetWindow!

    override init() {
        super.init(size: Constant.sceneSize)

        self.scaleMode = .aspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ui
    override func didMove(to view: SKView) {
        addBackground()
        addUI()
    }

    func addBackground() {
        let background = SKSpriteNode(imageNamed: Constant.ResourceName.bgPortal)

        background.position = Constant.screenUpRight
        background.zPosition = Constant.ZPosition.background

        self.addChild(background)
    }

    func addUI() {
        let uiLayer = SKNode()

        addButton(to: uiLayer)
        addResetWindow(uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func addButton(to parent: SKNode) {
        var texture = SKTexture(imageNamed: Constant.ResourceName.button)

        let enterButton = Button(texture: texture,
                                 frame: Constant.Frame.enterButton,
                                 text: "Enter World",
                                 eventType: PortalEventType.enterButton)
        parent.addChild(enterButton)

        let resetButton = Button(texture: texture,
                                 frame: Constant.Frame.resetButton,
                                 text: "Reset",
                                 eventType: PortalEventType.resetButton)
        parent.addChild(resetButton)

        texture = SKTexture(imageNamed: Constant.ResourceName.discordButton)

        let discordButton = Button(texture: texture,
                                   frame: Constant.Frame.discordButton,
                                   eventType: PortalEventType.discordButton)
        parent.addChild(discordButton)
    }

    func addResetWindow(_ parent: SKNode) {
        let resetWindow = ResetWindow()
        parent.addChild(resetWindow)
        self.resetWindow = resetWindow

        resetWindow.setUp()
    }

    override func update(_ currentTime: TimeInterval) {
        while let event = PortalEventManager.default.dequeue() {
            let portalEventType = event.type as! PortalEventType
            portalEventType.handler(self, event)
        }
    }

}

extension PortalScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchBegan(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchMoved(touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchEnded(touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchCancelled(touch)
        }
    }

}
