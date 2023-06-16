//
//  MovingLayer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class MovingLayer: LMINode {

    private var velocityVector: CGVector

    // TODO: add character and set it's position
    private var lastCharacterPosition: CGPoint
    var characterPosition: CGPoint {
        get { -self.position + (Constant.sceneCenter - CGPoint()) }
        set {
            self.lastCharacterPosition = self.characterPosition
            self.position = -newValue + (Constant.sceneCenter - CGPoint())
        }
    }
    private func move(difference: CGVector) { self.characterPosition += difference }

    override var position: CGPoint {
        get { super.position }
        set { super.position = newValue }
    }

    override init() {
        self.velocityVector = CGVector(dx: 0, dy: 0)
        self.lastCharacterPosition = CGPoint()

        super.init()

        let originNode = GameObject.new(of: .pineCone)
        self.addChild(originNode)

        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.movingLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(characterPosition: CGPoint) {
        self.characterPosition = characterPosition
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        guard self.touchManager.first(of: MovingLayerTouch.self) == nil else {
            return
        }

        let movingLayerTouch = MovingLayerTouch(touch: touch, sender: self)
        movingLayerTouch.previousTimestamp = touch.timestamp
        self.touchManager.add(movingLayerTouch)
    }

    override func touchMoved(_ touch: UITouch) {
        guard let movingLayerTouch = self.touchManager.first(from: touch) as! MovingLayerTouch? else {
            return
        }

        let previousPoint = touch.previousLocation(in: self.worldScene)
        let currentPoint = touch.location(in: self.worldScene)
        let difference = currentPoint - previousPoint

        self.characterPosition -= difference

        movingLayerTouch.previousPreviousTimestamp = movingLayerTouch.previousTimestamp
        movingLayerTouch.previousTimestamp = touch.timestamp
        movingLayerTouch.previousPreviousLocation = previousPoint
    }

    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.first(from: touch) != nil else {
            return
        }

        self.setVelocityVector()
        self.resetTouch(touch)
    }

    private func setVelocityVector() {
        let movingLayerTouch = self.touchManager.first(of: MovingLayerTouch.self) as! MovingLayerTouch

        guard let previousPreviousLocation = movingLayerTouch.previousPreviousLocation else {
            return
        }

        let previousLocation = movingLayerTouch.uiTouch.previousLocation(in: self.worldScene)
        let timeInterval = movingLayerTouch.previousTimestamp - movingLayerTouch.previousPreviousTimestamp

        self.velocityVector = -(previousLocation - previousPreviousLocation) / timeInterval
    }

    override func touchCancelled(_ touch: UITouch) {
        guard self.touchManager.first(from: touch) != nil else { return }
        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.touchManager.removeFirst(from: touch)
    }

}

// MARK: - private methods
extension MovingLayer {

    // MARK: update
    func update(_ timeInterval: TimeInterval) {
        self.updatePosition(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()
        self.tileDidMoved()
    }

    private func updatePosition(_ timeInterval: TimeInterval) {
        let differenceVector = self.velocityVector * timeInterval
        self.move(difference: differenceVector)
    }

    private func updateVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude
        self.velocityVector =
            velocity <= Constant.velocityDamping
            ? CGVector(dx: 0.0, dy: 0.0)
            // TODO: update wrong formula
            : self.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    private func resolveCollision() {
//        self.resolveWorldBorderCollision()
        self.resolveCollisionOfNonWalkable()
    }

    private func resolveWorldBorderCollision() {
        self.characterPosition.x = self.characterPosition.x < Constant.moveableArea.minX
            ? Constant.moveableArea.minX
            : self.characterPosition.x
        self.characterPosition.x = self.characterPosition.x > Constant.moveableArea.maxX
            ? Constant.moveableArea.maxX
            : self.characterPosition.x
        self.characterPosition.y = self.characterPosition.y < Constant.moveableArea.minY
            ? Constant.moveableArea.minY
            : self.characterPosition.y
        self.characterPosition.y = self.characterPosition.y > Constant.moveableArea.maxY
            ? Constant.moveableArea.maxY
            : self.characterPosition.y
    }

    private func resolveCollisionOfNonWalkable() {
        for go in self.worldScene.interactionZone.gos {
            guard !go.isWalkable else { continue }

            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius) {
                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius)
            }
        }
    }

    private func tileDidMoved() {
        let lastTile = TileCoordinate(from: self.lastCharacterPosition)
        let currentTile = TileCoordinate(from: self.characterPosition)

        if currentTile != lastTile {
            self.worldScene.interactionZone.reserveUpdate()
        }
    }

}

class MovingLayerTouch: TouchModel {

    var previousPreviousTimestamp: TimeInterval!
    var previousTimestamp: TimeInterval!
    var previousPreviousLocation: CGPoint!

}
