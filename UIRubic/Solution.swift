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
        if self.cube == Cube() {
            return self.cube
        }
        stepFirst()
        stepSecond()
        stepThree()
        stepFour()
        stepFive()
        stepSix()
        stepSeven()
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
                pifPafRight(face: faceOnePifPaf)
                moveNumberToCorner(face: face, number: number)
                moveNuberToDown(face: face, number: number)
            }
        }
    }
    
    // Комбинация пиф-паф (относительно текущей грани face R U R' U')
    private func pifPafRight(face: Face) {
        let flipRight = face.flip.faceRight()!
        self.cube.flip(flipRight)
        self.cube.flip(.U)
        self.cube.flip(flipRight.faceOpposite()!)
        self.cube.flip(._U)
    }
    
    // Комбинация пиф-паф влево (относительно текущей грани face L' U' L U)
    private func pifPafLeft(face: Face) {
        let flipLeft = face.flip.faceLeft()!
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
            pifPafRight(face: face)
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
        while !isSecondLayer() {
            forFlipRight()
            forFlipLeft()
            rotateRightsNumber()
        }
    }
    
    // Проверяет собран ли второй слой. Слева и справа цвета от центра должны совпадать.
    private func isSecondLayer() -> Bool {
        for face in self.cube.faces[0...3] {
            if face.matrix[1][0] != face.color || face.matrix[1][2] != face.color {
                return false
            }
        }
        return true
    }
    
    // Для поворота из центральной верхней точки грани вправо.
    private func forFlipRight() {
        for (face, number) in zip(self.cube.faces[0...3], [5, 23, 21, 3]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(.U)
                pifPafRightLeft(face: face)
            }
        }
    }
    
    // Для поворота из центральной верхней точки грани влево.
    private func forFlipLeft() {
        for (face, number) in zip(self.cube.faces[0...3], [3, 5, 23, 21]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(._U)
                pifPafLeftRight(face: face)
            }
        }
    }
    
    // Разворачавает цвета в правом центрально кубике текущей грани. Меняет их местами.
    private func rotateRightsNumber() {
        for face in self.cube.faces[0...3] {
            if face.matrix[1][2] != face.color {
                pifPafRightLeft(face: face)
                return
            }
        }
    }
    
    // Комбинация R U R' U' -> L' U' L U
    private func pifPafRightLeft(face: Face) {
        pifPafRight(face: face)
        pifPafLeft(face: self.cube.faces[(face.index + 1) % 4])
    }
    
    // Комбинация L' U' L U <- R U R' U'
    private func pifPafLeftRight(face: Face) {
        pifPafLeft(face: face)
        let index = (face.index - 1) < 0 ? 3 : face.index - 1
        pifPafRight(face: self.cube.faces[index])
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
    
    // MARK: Этап четвертый. Сборка последнего слоя.
    private func stepFour() {
        if !isYellowCross() {
            yellowDot()
            yellowHalfCross()
            yellowStick()
        }
    }
    
    // Если вверху палка.
    private func yellowStick() {
        //print("yellowStick")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][0] == .yellow && faceUp.matrix[1][2] == .yellow {
            self.cube.flip(.F)
            pifPafRight(face: self.cube.getFase(type: .f))
            self.cube.flip(._F)
        }
        if faceUp.matrix[2][1] == .yellow && faceUp.matrix[0][1] == .yellow {
            self.cube.flip(.R)
            pifPafRight(face: self.cube.getFase(type: .r))
            self.cube.flip(._R)
        }
    }
    
    // Если вверху палка.
    private func yellowHalfCross() {
        //print("yellowHalfCross")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][2] == .yellow && faceUp.matrix[0][1] == .yellow {
            self.cube.flip(.L)
            pifPafRight(face: self.cube.getFase(type: .l))
            self.cube.flip(._L)
        }
        if faceUp.matrix[0][1] == .yellow && faceUp.matrix[1][0] == .yellow {
            self.cube.flip(.F)
            pifPafRight(face: self.cube.getFase(type: .f))
            self.cube.flip(._F)
        }
        if faceUp.matrix[1][0] == .yellow && faceUp.matrix[2][1] == .yellow {
            self.cube.flip(.R)
            pifPafRight(face: self.cube.getFase(type: .r))
            self.cube.flip(._R)
        }
        if faceUp.matrix[2][1] == .yellow && faceUp.matrix[1][2] == .yellow {
            self.cube.flip(.B)
            pifPafRight(face: self.cube.getFase(type: .b))
            self.cube.flip(._B)
        }
    }
    
    // Если точка вверхней части.
    private func yellowDot() {
        //print("yellowDot")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][0] != .yellow && faceUp.matrix[2][1] != .yellow &&
            faceUp.matrix[1][2] != .yellow && faceUp.matrix[0][1] != .yellow {
            self.cube.flip(.L)
            pifPafRight(face: self.cube.getFase(type: .l))
            self.cube.flip(._L)
        }
    }
    
    // Проверяет наличие желтого креста в верхнем слое (Up)
    private func isYellowCross() -> Bool {
        return
            self.cube.faces[4].matrix[1][0] == .yellow &&
            self.cube.faces[4].matrix[2][1] == .yellow &&
            self.cube.faces[4].matrix[1][2] == .yellow &&
            self.cube.faces[4].matrix[0][1] == .yellow
    }
    
    // MARK: Пятый этап. Првильный желтый крест.
    private func stepFive() {
        nearby()
        opposite()
        nearby()
    }
    
    // Проверка постояния Рядом
    private func nearby() {
        for index in 0...3 {
            let indexNext = (index + 1) % 4
            let indexPrevious = (index - 1) < 0 ? 3 : index - 1
            locateCollor(face: self.cube.faces[index])
            if isCorrect(face: self.cube.faces[indexNext]) && !isCorrect(face: self.cube.faces[indexPrevious]){
                //let indexPrevious = (face.index - 1) < 0 ? 4 : face.index - 1
                caseNearby(face: self.cube.faces[index])
                //print("Nearby")
            }
        }
    }
    
    // Проверка состояния Напротив.
    private func opposite() {
        for index in 0...3 {
            let indexNext = (index + 2) % 4
            let indexPrevious = (index - 1) < 0 ? 3 : index - 1
            locateCollor(face: self.cube.faces[index])
            if isCorrect(face: self.cube.faces[indexNext]) && !isCorrect(face: self.cube.faces[indexPrevious]) {
                //let indexPrevious = (face.index - 1) < 0 ? 4 : face.index - 1
                caseOpposite(face: self.cube.faces[index])
                //print("Opposite")
            }
        }
    }
    
    // Доводит цвет до своей грани в верхней части.
    private func locateCollor(face: Face) {
        while !isCorrect(face: face) {
            self.cube.flip(.U)
        }
    }
    
    // Проверяет является ли верным цвет вверху текущей грани.
    private func isCorrect(face: Face) -> Bool{
        return self.cube.faces[face.index].matrix[0][1] == face.color
    }
    
    // Комбинация для случая "Рядом"
    private func caseNearby(face: Face) {
        self.cube.flip(face.flip)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceOpposite()!)
        self.cube.flip(.U)
        self.cube.flip(face.flip)
        self.cube.flip(.U)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceOpposite()!)
        self.cube.flip(.U)
    }
    
    // Комбинация для случая "Напротив"
    private func caseOpposite(face: Face) {
        self.cube.flip(face.flip.faceRight()!)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceRight()!.faceOpposite()!)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceRight()!)
        self.cube.flip(.U)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceRight()!.faceOpposite()!)
    }
    
    // Проверяет получился ли крест.
    private func isCross() -> Bool {
        for face in self.cube.faces[0...3] {
            if !isCorrect(face: face) {
                return false
            }
        }
        return true
    }
    
    // Крутим указанное число на правое место в координиту [2][2][1].
    private func moveLocationRight(number: Int8) {
        while cube.numbers[2][2][1] != number {
            self.cube.flip(.U)
        }
    }
    
    // MARK: Этап шесть. Расстановка углов в верхнем слое.
    private func stepSix() {
        while !isCorner() {
            arrangeСorners()
        }
    }
    
    // Вращение для расстановки углов третьего слоя.
    private func arrangeСorners() {
        for (face, number) in zip(self.cube.faces[0...3], [6, 8, 26, 24]) {
            if isLocalCorner(number: Int8(number)) {
                flipCorners(face: face)
                return
            }
        }
        flipCorners(face: self.cube.faces[0])
    }
    
    // Выполняет комбинацию (R U' L' U R' U' L U) относительно текущей грани.
    private func flipCorners(face: Face) {
        self.cube.flip(face.flip.faceRight()!)
        self.cube.flip(._U)
        self.cube.flip(face.flip.faceLeft()!.faceOpposite()!)
        self.cube.flip(.U)
        self.cube.flip(face.flip.faceRight()!.faceOpposite()!)
        self.cube.flip(._U)
        self.cube.flip(face.flip.faceLeft()!)
        self.cube.flip(.U)
    }
    
    // Проверяет, находится ли заданный кубик на своем месте.
    private func isLocalCorner(number: Int8) -> Bool {
        switch number {
        case 6:
            return self.cube.numbers[0][2][0] == number
        case 8:
            return self.cube.numbers[0][2][2] == number
        case 26:
            return self.cube.numbers[2][2][2] == number
        case 24:
            return self.cube.numbers[2][2][0] == number
        default:
            print("Error isLocalCorner")
        }
        print("Error isLocalCorner!!!")
        return false
    }
    
    // Проверяет, находятся ли кубики в углах верхнего слоя на своих местах.
    private func isCorner() -> Bool {
        return
            self.cube.numbers[0][2][0] == 6 &&
            self.cube.numbers[0][2][2] == 8 &&
            self.cube.numbers[2][2][2] == 26 &&
            self.cube.numbers[2][2][0] == 24
    }
    
    // MARK: Седьмой этап. Разворот углов.
    private func stepSeven() {
        for face in self.cube.faces[0...3] {
            if !equalCenterCornerLeft(face: face) {
                turningCorners(face: self.cube.faces[face.index])
                break
            }
        }
        moveLocationRight(number: 25)
    }
    
    // Производит разворот углов до полной собраности кубика.
    private func turningCorners(face: Face) {
        if isSolution() { return }
        let indexLeft = face.index - 1 < 0 ? 3 : face.index - 1
        while !equalCenterCornerLeft(face: self.cube.faces[face.index]) || !equalCenterCornerRight(face: self.cube.faces[indexLeft]) {
            invertedPifPaf(face: face)
        }
        while equalCenterCornerLeft(face: self.cube.faces[face.index]) {
            self.cube.flip(.U)
            if isSolution() { return }
        }
        turningCorners(face: face)
    }
    
    // Перевернуный пифпаф для текущей грани (L D L' D')
    private func invertedPifPaf(face: Face) {
        self.cube.flip(face.flip.faceLeft()!)
        self.cube.flip(.D)
        self.cube.flip(face.flip.faceLeft()!.faceOpposite()!)
        self.cube.flip(._D)
    }
    
    // Проверяет совпадают ли цвета в левом верхнем углу грани и центральный.
    private func equalCenterCornerLeft(face: Face) -> Bool {
        return face.matrix[0][0] == face.matrix[0][1]
    }
    
    // Проверяет совпадают ли цвета в правом верхнем углу грани и центральный.
    private func equalCenterCornerRight(face: Face) -> Bool {
        return face.matrix[0][1] == face.matrix[0][2]
    }
    
    // Проверка на решение головоломки.
    private func isSolution() -> Bool {
        for face in self.cube.faces[0...3] {
            if !equalCenterCornerLeft(face: face) || !equalCenterCornerRight(face: face) {
                return false
            }
        }
        return true
    }
}
