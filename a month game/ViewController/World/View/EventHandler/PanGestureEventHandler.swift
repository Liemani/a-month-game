//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class PanGestureEventHandler: EventHandler {

    private var gesture: UIPanGestureRecognizer?

    private weak var view: SKView!
    private let character: Character

    private var pPoint: CGPoint!
    private var cPoint: CGPoint!

    func locationInScene() -> CGPoint {
        let viewPoint = self.gesture!.location(in: self.view)

        return self.view.scene!.convertPoint(fromView: viewPoint)
    }

    func velocityInScene() -> CGPoint {
        let viewVelocity = self.gesture!.velocity(in: self.view)

        return self.view.scene!.convertPoint(fromView: viewVelocity)
    }

    // MARK: - init
    init(view: SKView, character: Character) {
        self.view = view
        self.character = character

        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handle(_:)))
        view.addGestureRecognizer(panGesture)
    }

    typealias method = (PanGestureEventHandler) -> () -> ()

    static let table: [UIGestureRecognizer.State: method] = [
        .began: began,
        .changed: changed,
        .ended: ended,
        .cancelled: cancelled,
    ]

}

extension PanGestureEventHandler: GestureEventHandler {

    @objc func handle(_ gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            self.gesture = gesture as! UIPanGestureRecognizer?
        }

        PanGestureEventHandler.table[gesture.state]!(self)()
    }

    func began() {
        self.gesture!.maximumNumberOfTouches = 1
        self.character.velocity = CGPoint()
        self.pPoint = nil
        self.cPoint = self.locationInScene()
    }

    func changed() {
        let cPoint = self.locationInScene()
        let difference = cPoint - self.cPoint

        self.character.position -= difference

        self.pPoint = self.cPoint
        self.cPoint = cPoint

    }

    func ended() {
        guard let pPoint = self.pPoint else {
            return
        }

        let scene = self.view.scene as! WorldScene
        self.character.velocity = (pPoint - self.cPoint) / scene.timeInterval

        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.gesture = nil
    }

}
