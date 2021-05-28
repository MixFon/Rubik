//
//  Solution.swift
//  UIRubic
//
//  Created by Михаил Фокин on 27.05.2021.
//

import Foundation

class Solution {
    var cube: Cube
    
    init(cube: Cube) {
        cube.path.removeAll()
        self.cube = cube
    }
    
    func solution() -> Cube {
        stepFirst()
        stepSecond()
        stepThree()
        return self.cube
    }
    
    // MARK: Первый этап. Правильный крест.
    // Повторять пока не будет получаться цветок.
    private func stepFirst() {
        while !isFlower() {
            flower()
        }
        cross()
    }

    // Проверяет достигли ли состояния "цветка"
    private func isFlower() -> Bool {
        return
            self.cube.faces[4].matrix[1][0] == .white &&
            self.cube.faces[4].matrix[2][1] == .white &&
            self.cube.faces[4].matrix[1][2] == .white &&
            self.cube.faces[4].matrix[0][1] == .white
    }
    
    // Собираем ромашку.
    private func flower() {
        // Грань L
        if cube.faces[0].matrix[1][0] == .white {
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        if cube.faces[0].matrix[1][2] == .white {
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .clockwise)        // F
        }
        if cube.faces[0].matrix[0][1] == .white {
            cube.flipLeft(turn: .counterclockwise)  // L'
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        if cube.faces[0].matrix[2][1] == .white {
            cube.flipLeft(turn: .clockwise)         // L
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        
        // Грань F
        if cube.faces[1].matrix[1][0] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[1].matrix[1][2] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .clockwise)        // R
        }
        if cube.faces[1].matrix[0][1] == .white {
            cube.flipFront(turn: .counterclockwise) // F'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[1].matrix[2][1] == .white {
            cube.flipFront(turn: .clockwise)        // L
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        
        // Грань R
        if cube.faces[2].matrix[1][0] == .white {
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) //F'
        }
        if cube.faces[2].matrix[1][2] == .white {
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .clockwise)         // B
        }
        if cube.faces[2].matrix[0][1] == .white {
            cube.flipRight(turn: .counterclockwise) // R'
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) // F'
        }
        if cube.faces[2].matrix[2][1] == .white {
            cube.flipRight(turn: .clockwise)        // R
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) // F'
        }
        
        // Грань B
        if cube.faces[3].matrix[1][0] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        if cube.faces[3].matrix[1][2] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .clockwise)         // L
        }
        if cube.faces[3].matrix[0][1] == .white {
            cube.flipBack(turn: .counterclockwise)  // B'
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        if cube.faces[3].matrix[2][1] == .white {
            cube.flipBack(turn: .clockwise)         // B
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        
        // Грань D
        if cube.faces[5].matrix[1][0] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[5].matrix[1][2] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .clockwise)        // R
            cube.flipRight(turn: .clockwise)        // R
        }
        if cube.faces[5].matrix[0][1] == .white {
            cube.flipDown(turn: .counterclockwise)  // D'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[5].matrix[2][1] == .white {
            cube.flipDown(turn: .clockwise)         // D'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
    }
    
    // Поворачивает верхнюю грань для освобождения свободного места.
    private func isAveilable(i: Int, j: Int) {
        while self.cube.faces[4].matrix[i][j] == .white {
            self.cube.flipUp(turn: .clockwise)
        }
    }
    
    // Перебирает грани с 0 по 3 и подводит к ним номера кубиков [1, 11, 19, 9].
    private func cross() {
        for (face, number) in zip(self.cube.faces[0...3], [1, 11, 19, 9]) {
            moveNumberForCross(face: face, number: number)
            self.cube.flip(face.flip)
            self.cube.flip(face.flip)
        }
    }
    
    private func moveNumberForCross(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 1)
        case .F:
            coordinate = (1, 2, 2)
        case .R:
            coordinate = (2, 2, 1)
        case .B:
            coordinate = (1, 2, 0)
        default:
            coordinate = (0, 0, 0)
            print("Error move number for cross.")
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != Int8(number) {
            self.cube.flip(.U)
        }
    }
    
    //MARK: Второй этап. Первый слой.
    // Перебор граней от 0 до 3. [2, 20, 18, 0] - номера кубиков, которе должны переместить.
    private func stepSecond() {
        for (face, number) in zip(self.cube.faces[0...3], [2, 20, 18, 0]) {
            if isNumberInCornerUp(number: number) {
                moveNumberToCorner(face: face, number: number)
                moveNuberToDown(face: face, number: number)
            } else {
                let faceOnePifPaf = moveNuberFromDown(number: number)!
                pifPafRighr(fase: faceOnePifPaf)
                moveNumberToCorner(face: face, number: number)
                moveNuberToDown(face: face, number: number)
            }
        }
    }
    
    // Комбинация пиф-паф (относительно текущей грани face R U R' U')
    private func pifPafRighr(fase: Face) {
        let flipRight = fase.flip.faceRight()!
        self.cube.flip(flipRight)
        self.cube.flip(.U)
        self.cube.flip(flipRight.faceOpposite()!)
        self.cube.flip(._U)
    }
    
    // Комбинация пиф-паф влево (относительно текущей грани face L' U' L U)
    private func pifPafLeft(fase: Face) {
        let flipLeft = fase.flip.faceLeft()!
        self.cube.flip(flipLeft.faceOpposite()!)
        self.cube.flip(._U)
        self.cube.flip(flipLeft)
        self.cube.flip(.U)
    }
    
    // Проверка находится ли номер в верхнем слое в УГЛАХ (где Up)
    private func isNumberInCornerUp(number: Int) -> Bool {
        return
            self.cube.numbers[0][2][0] == Int8(number) ||
            self.cube.numbers[0][2][2] == Int8(number) ||
            self.cube.numbers[2][2][2] == Int8(number) ||
            self.cube.numbers[2][2][0] == Int8(number)
    }
    
    // Проверка находится ли номер в верхнем слое в ЦЕНТРЕ (где Up)
    private func isNumberInCentreUp(number: Int) -> Bool {
        return
            self.cube.numbers[0][2][1] == Int8(number) ||
            self.cube.numbers[1][2][2] == Int8(number) ||
            self.cube.numbers[2][2][1] == Int8(number) ||
            self.cube.numbers[1][2][0] == Int8(number)
    }
    
    
    // Передвижение номера в правый верхний угол заданной грани. Координаты этих углов.
    private func moveNumberToCorner(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 2)
        case .F:
            coordinate = (2, 2, 2)
        case .R:
            coordinate = (2, 2, 0)
        case .B:
            coordinate = (0, 2, 0)
        default:
            print("Error move number.")
            coordinate = (0, 0, 0)
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            self.cube.flip(.U)
        }
    }
    
    // Перемещение с помощью пиф-паф помещаем номера в правый нижний угол грани в нижний ряд (где Down).
    private func moveNuberToDown(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 0, 2)
        case .F:
            coordinate = (2, 0, 2)
        case .R:
            coordinate = (2, 0, 0)
        case .B:
            coordinate = (0, 0, 0)
        default:
            print("Error move number.")
            coordinate = (0, 0, 0)
        }
        while self.cube.faces[face.index].matrix[2][2] != face.color || self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            pifPafRighr(fase: face)
        }
    }
    
    // Поднимаем кубик из нижней грани наверх.
    private func moveNuberFromDown(number: Int) -> Face? {
        switch Int8(number) {
        case self.cube.numbers[0][0][2]:
            return self.cube.faces[0]
        case self.cube.numbers[2][0][2]:
            return self.cube.faces[1]
        case self.cube.numbers[2][0][0]:
            return self.cube.faces[2]
        case self.cube.numbers[0][0][0]:
            return self.cube.faces[3]
        default:
            return nil
        }
    }
    
    // MARK: Этап третий. Средний слой.
    private func stepThree() {
        forFlipRighr()
        forFlipLeft()
    }
    
    // Для поворота из центральной верхней вправо.
    private func forFlipRighr() {
        for (face, number) in zip(self.cube.faces[0...3], [5, 23, 21, 3]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(.U)
                pifPafRighr(fase: face)
                pifPafLeft(fase: self.cube.faces[(face.index + 1) % 4])
            }
        }
    }
    
    // Для поворота из центральной верхней влево.
    private func forFlipLeft() {
        for (face, number) in zip(self.cube.faces[0...3], [3, 5, 23, 21]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(._U)
                pifPafLeft(fase: face)
                let index = (face.index - 1) < 0 ? 4 : face.index - 1
                pifPafRighr(fase: self.cube.faces[index])
            }
        }
    }
    
    // Передвижение номера в центры верхней грани. Координаты этих углов.
    private func moveNumberToСentre(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 1)
        case .F:
            coordinate = (1, 2, 2)
        case .R:
            coordinate = (2, 2, 1)
        case .B:
            coordinate = (1, 2, 0)
        default:
            print("Error move number to centre.")
            coordinate = (0, 0, 0)
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            self.cube.flip(.U)
        }
    }
}
