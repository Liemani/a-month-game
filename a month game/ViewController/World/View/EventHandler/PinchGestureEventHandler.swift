//
//  PinchGestureEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/29.
//

import Foundation
import SpriteKit

final class PinchGestureEventHandler: EventHandler {

    private var gesture: UIPinchGestureRecognizer?

    private weak var view: SKView!
    private let world: SKNode
    private let character: Character

    private var pPoint: CGPoint!
    private var pScale: Double

    func locationInScene() -> CGPoint {
        let viewPoint = self.gesture!.location(in: self.view)
        return self.view.scene!.convertPoint(fromView: viewPoint)
    }

    // MARK: - init
    init(view: SKView, world: SKNode, character: Character) {
        self.view = view
        self.world = world
        self.character = character

        self.pScale = 1.0

        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(handle(_:)))
        view.addGestureRecognizer(pinchGesture)
    }

    typealias method = (PinchGestureEventHandler) -> () -> ()

    static let table: [UIGestureRecognizer.State: method] = [
        .began: began,
        .changed: changed,
        .ended: ended,
        .cancelled: cancelled,
    ]

}

extension PinchGestureEventHandler: GestureEventHandler {

    @objc func handle(_ gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            self.gesture = gesture as! UIPinchGestureRecognizer?
        }

        PinchGestureEventHandler.table[gesture.state]!(self)()
    }

    func began() {
        self.character.velocity = CGPoint()
        self.pPoint = self.locationInScene()
        self.pScale = self.gesture!.scale
    }

    func changed() {
        let cPoint = self.locationInScene()
        let midPoint = (cPoint + self.pPoint) / 2
        
        let cScale = self.gesture!.scale
        let scaleDifference = cScale / pScale
        var scale = self.world.xScale * scaleDifference
        scale = max(Constant.minZoomScale, scale)
        scale = min(scale, Constant.maxZoomScale)

        self.world.xScale = scale
        self.world.yScale = scale

        self.pPoint = cPoint
        self.pScale = cScale
    }

    func ended() {
        self.complete()
    }

    func cancelled() {

        self.complete()
    }

    func complete() {
        self.gesture = nil
    }

}
