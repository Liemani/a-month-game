//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class CharacterMoveTouchEventHandler {

    let recognizer: UIGestureRecognizer

    private let view: SKView
    private let character: Character

    private var pPoint: CGPoint!
    private var cPoint: CGPoint!

    // MARK: - init
    init(recognizer: UIGestureRecognizer, view: SKView, character: Character) {
        self.recognizer = recognizer
        self.view = view
        self.character = character
    }

    func locationInScene(recognizer: UIGestureRecognizer) -> CGPoint {
        let viewPoint = self.recognizer.location(in: self.view)
        return self.view.scene!.convertPoint(fromView: viewPoint)
    }

}

extension CharacterMoveTouchEventHandler: GestureEventHandler {

    func began() {
        self.character.velocityVector = CGVector()
        self.cPoint = self.locationInScene(recognizer: self.recognizer)
    }

    func moved() {
        self.pPoint = self.cPoint
        self.cPoint = self.locationInScene(recognizer: self.recognizer)
        let difference = self.cPoint - self.pPoint

        self.character.position -= difference
    }

    func ended() {
        self.setCharacterVelocity()
    }

    private func setCharacterVelocity() {
        guard self.pPoint != nil else { return }

        let timeInterval = (self.view.scene as! WorldScene).timeInterval

        self.character.velocityVector = (-(self.cPoint - self.pPoint) / timeInterval).vector

        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        GestureEventHandlerManager.default.remove(from: self.recognizer)
    }

}
