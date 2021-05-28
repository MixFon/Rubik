//
//  TempData.swift
//  UIRubic
//
//  Created by Михаил Фокин on 27.05.2021.
//

import Foundation
/*
// MARK: Вращение и движение кубиков.
private func moveRotateNode(nodes: [SCNNode], axis: Axis, turn: Turn) -> Bool {
    if nodes.count != 9 { return false }
    if !checkLokationNodes(nodes: nodes) { return true }
    nodes.forEach( {
        animateRotateMoveNode(node: $0, axis: axis, turn: turn)
    } )
    self.flag = true
    return true
}

// MARK: Проверяет позицию всех кубиков. Они должны стоять в 4, -4, 0
private func checkLokationNodes(nodes: [SCNNode]) -> Bool {
    for node in nodes {
        if !isCorrectСoordinates(coordinate: node.position.x){
            return false
        }
        if !isCorrectСoordinates(coordinate: node.position.y){
            return false
        }
        if !isCorrectСoordinates(coordinate: node.position.z){
            return false
        }
    }
    return true
}

// MARK: Проверяет координаты. Они должны бить 0, 4, -4
private func isCorrectСoordinates(coordinate: CGFloat) -> Bool {
    switch coordinate {
    case 0:
        return true
    case 4:
        return true
    case -4:
        return true
    default:
        return false
    }
}

// MARK: Вращение левой грани L по или против часовой стрелке.
private func flipLeft(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.x == -4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .X, turn: turn) { return }
    }
}

// MARK: Вращение верхней грани U по или против часовой стрелке.
private func flipUp(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.y == 4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .Y, turn: turn) { return }
    }
}

// MARK: Вращение нижней грани D по или против часовой стрелке.
private func flipDown(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.y == -4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .Y, turn: turn) { return }
    }
}

// MARK: Вращение правой грани R по или против часовой стрелке.
private func flipRight(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.x == 4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .X, turn: turn) { return }
    }
}

// MARK: Вращение передней грани F по или против часовой стрелке.
private func flipFront(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.z == 4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .Z, turn: turn) { return }
    }
}

// MARK: Вращение передней грани B по или против часовой стрелке.
private func flipBack(turn: Turn) {
    while true {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.z == -4 } ) else { return }
        if moveRotateNode(nodes: nodes, axis: .Z, turn: turn) { return }
    }
}

// MARK: Впредвижение ПО или ПРОТИВ часовой стредке, вокруг указанной оси.
private func animateRotateMoveNode(node: SCNNode, axis: Axis, turn: Turn) {
    var position = node.position
    let chengeCoordinate: (inout CGFloat, inout CGFloat) -> ()
    let angle: CGFloat
    var positionAxis: SCNVector3
    if turn == .clockwise {
        angle = .pi / 2
        chengeCoordinate = chengeCoordinateClockwise
    } else {
        angle = -.pi / 2
        chengeCoordinate =  chengeCoordinateCounterclockwise
    }
    switch axis {
    case .X:
        positionAxis = SCNVector3(1, 0, 0)
        chengeCoordinate(&position.z, &position.y)
    case .Y:
        positionAxis = SCNVector3(0, 1, 0)
        chengeCoordinate(&position.x, &position.z)
    case .Z:
        positionAxis = SCNVector3(0, 0, 1)
        chengeCoordinate(&position.y, &position.x)
    }
    let move = SCNAction.move(to: position, duration: self.duration)
    move.timingMode = .easeInEaseOut
    let rotate = SCNAction.rotate(by: angle, around: positionAxis, duration: self.duration)
    rotate.timingMode = .easeInEaseOut
    let moveRotate = SCNAction.group([move, rotate])
    //node.runAction(move)
    node.runAction(moveRotate)
//        let action = SCNAction.customAction(duration: 0, action: { (nodeA, timer) in
//
//        })
//        actions.append(action)
}

// MARK: Высичляет новые коорлинаты для ячейки, при повороте ПО часовой стрелке.
private func chengeCoordinateClockwise( left: inout CGFloat, right: inout CGFloat)  {
    if left + right == 0 {
        left = -left
    } else if abs(left + right) == 8 {
        right = -right
    } else if abs(left + right) == 4 {
        if left == 0 {
            (left, right) = (right, left)
        } else {
            (left, right) = (-right, -left)
        }
    }
}

// MARK: Высичляет новые коорлинаты для ячейки, при повороте ПРОТИВ часовой стрелки.
private func chengeCoordinateCounterclockwise( left: inout CGFloat, right: inout CGFloat) {
    if left + right == 0 {
        right = -right
    } else if abs(left + right) == 8 {
        left = -left
    } else if abs(left + right) == 4 {
        if left == 0 {
            (left, right) = (-right, -left)
        } else {
            (left, right) = (right, left)
        }
    }
}
 
 // MARK: Выполнение заданной последовательности вращений куба.
 func flipCube(flip: String) -> Bool {
     
     guard self.flag else { return  false }
     self.flag = false
     usleep(useconds_t(1000000 * self.duration + 50000))
//        sleep(1)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Put your code which should be executed with a delay here
//        }
     print(flip)
     switch flip {
     case "L":
         self.flipLeft(turn: .clockwise)
     case "L'":
         self.flipLeft(turn: .counterclockwise)
     case "U":
         self.flipUp(turn: .counterclockwise)
     case "U'":
         self.flipUp(turn: .clockwise)
     case "D":
         self.flipDown(turn: .clockwise)
     case "D'":
         self.flipDown(turn: .counterclockwise)
     case "R":
         self.flipRight(turn: .counterclockwise)
     case "R'":
         self.flipRight(turn: .clockwise)
     case "F":
         self.flipFront(turn: .counterclockwise)
     case "F'":
         self.flipFront(turn: .clockwise)
     case "B":
         self.flipBack(turn: .clockwise)
     case "B'":
         self.flipBack(turn: .counterclockwise)
     default:
         break
     }
     return true
 }
 
*/
