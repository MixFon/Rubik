//
//  Cube.swift
//  UIRubic
//
//  Created by Михаил Фокин on 20.05.2021.
//

import SceneKit

class Cube {
    
    var faces = [Face]()
    var f: Int
    var g: Int
    var path: [Flip]
    var numbers: [[[Int8]]]
    
    enum FaceType: Int {
        case l = 0
        case f = 1
        case r = 2
        case b = 3
        case u = 4
        case d = 5
    }
    
    init() {
        let colors: [Color] = [.orange, .blue, .red, .green, .yellow, .white]
        let flips = Flip.flipClockwise
        self.f = 0
        self.path = [Flip]()
        self.numbers = Array(repeating: Array(repeating: Array(repeating: Int8(0), count: 3), count: 3), count: 3)
        self.g = 0
        fillNumberCube()
        for (i, (color, flip)) in zip(colors, flips).enumerated() {
            self.faces.append(Face(color: color, flip: flip, index: i))
        }
    }
    
    // Конструктор копирования.
    init(cube: Cube) {
        for face in cube.faces {
            self.faces.append(face)
        }
        //self.faces = cube.faces
        //self.faces = []
        self.f = cube.f
        self.path = cube.path
        self.numbers = cube.numbers
        self.g = cube.g + 1
        //self.coordinats = cube.coordinats
    }
    
    // Заполнене 3x3x3 массива значениями.
    private func fillNumberCube() {
        //print(self.numbers)
        var elem: Int8 = 0
        for i in 0...2 {
            for j in 0...2 {
                for k in 0...2 {
                    self.numbers[i][j][k] = elem
                    //self.coordinats[elem] = SCNVector3(i, j, k)
                    elem += 1
                }
            }
        }
        //print(self.numbers)
    }
    
    // Вывод граней кубика.
    func printCube() {
        self.faces.forEach({$0.printFace()})
    }
    
    // Устнавка эвристики.
    func setF(heuristic: Int) {
        self.f = heuristic + self.g
        //self.f = heuristic
    }
    
    // Печатает куб по слоям.
    func printLayers() {
        for j in 0...2 {
            print("j =", j)
            for k in 0...2 {
                for i in 0...2 {
                    print(String(format: "%2.1d", self.numbers[i][j][k]), terminator: " ")
                }
                print()
            }
        }
    }
    
    // MARK: Вращение куба 3x3x3
    // Изменение координат номеров. Передается константная ось и костантное значние на этой оси
    private func turnCoordinateNumber(axis: Axis, index: Int, turn: Turn) {
        let numbersCoordinate = getNumber(axis: axis, index: index)
        let turnNumber: (inout CGFloat, inout CGFloat) -> ()
//        if turn == .clockwise {
//            turnNumber = turnNumberClockwise
//        } else {
//            turnNumber = turnNumberСounterclockwise
//        }
        switch turn {
        case .clockwise:
            if index == 0 {
                turnNumber = turnNumberClockwise
            } else {
                turnNumber = turnNumberСounterclockwise
            }
        case .counterclockwise:
            if index == 0 {
                turnNumber = turnNumberСounterclockwise
            } else {
                turnNumber = turnNumberClockwise
            }
        }
        for var number in numbersCoordinate {
            switch axis {
            case .X:
                turnNumber(&number.1.z, &number.1.y)
            case .Y:
                turnNumber(&number.1.x, &number.1.z)
            case .Z:
                turnNumber(&number.1.y, &number.1.x)
            }
            self.numbers[Int(number.1.x)][Int(number.1.y)][Int(number.1.z)] = number.0
        }
    }
    
    // Вращение номеров ПО часовой стрелке.
    private func turnNumberClockwise(left: inout CGFloat, right: inout CGFloat) {
        if left == 1 && right == 1 {
            return
        }
        if left + right == 0 || left + right == 4 {
            right = abs(right - 2)
        } else if left + right == 2 {
            left = abs(left - 2)
        } else if left == 0 && right == 1 {
            (left, right) = (1, 2)
        } else if left == 1 && right == 2 {
            (left, right) = (2, 1)
        } else if left == 2 && right == 1 {
            (left, right) = (1, 0)
        } else if left == 1 && right == 0 {
            (left, right) = (0, 1)
        }
    }
    
    // Вращение номеров ПРОТИВ часовой стрелки.
    private func turnNumberСounterclockwise(left: inout CGFloat, right: inout CGFloat) {
        if left == 1 && right == 1 {
            return
        }
        if left + right == 0 || left + right == 4 {
            left = abs(left - 2)
        } else if left + right == 2 {
            right = abs(right - 2)
        } else if left == 0 && right == 1 {
            (left, right) = (1, 0)
        } else if left == 1 && right == 0 {
            (left, right) = (2, 1)
        } else if left == 2 && right == 1 {
            (left, right) = (1, 2)
        } else if left == 1 && right == 2 {
            (left, right) = (0, 1)
        }
    }
    
    // Собирает номера и коорлинаты на указанной грани и индексом.
    private func getNumber(axis: Axis, index: Int) -> [(Int8, SCNVector3)] {
        var numbers = [(Int8, SCNVector3)]()
        for a in 0...2 {
            for b in 0...2 {
                numbers.append(getNumberCoordinate(a, b, axis: axis, index: index))
            }
        }
        return numbers
    }
    
    //Возвращает номер и координату номера.
    private func getNumberCoordinate(_ a: Int, _ b: Int, axis: Axis, index: Int) -> (Int8, SCNVector3) {
        switch axis {
        case .X:
            return (self.numbers[index][a][b], SCNVector3(index, a, b))
        case .Y:
            return (self.numbers[a][index][b], SCNVector3(a, index, b))
        case .Z:
            return (self.numbers[a][b][index], SCNVector3(a, b, index))
        }
    }
    
    // MARK: Повороты faces
    // Вращение грани ПО или ПРОТИВ часовой стрелки гранией кубика.
    private func turnFace(type: FaceType, turn: Turn) {
        let index = type.rawValue
        writePath(type: type, turn: turn)
        if turn == .clockwise {
            (faces[index].matrix[0][0], faces[index].matrix[2][0], faces[index].matrix[2][2], faces[index].matrix[0][2]) =
            (faces[index].matrix[2][0], faces[index].matrix[2][2], faces[index].matrix[0][2], faces[index].matrix[0][0])

            (faces[index].matrix[0][1], faces[index].matrix[1][0], faces[index].matrix[2][1], faces[index].matrix[1][2]) =
            (faces[index].matrix[1][0], faces[index].matrix[2][1], faces[index].matrix[1][2], faces[index].matrix[0][1])
        } else {
            (faces[index].matrix[2][0], faces[index].matrix[2][2], faces[index].matrix[0][2], faces[index].matrix[0][0]) =
            (faces[index].matrix[0][0], faces[index].matrix[2][0], faces[index].matrix[2][2], faces[index].matrix[0][2])

            (faces[index].matrix[1][0], faces[index].matrix[2][1], faces[index].matrix[1][2], faces[index].matrix[0][1]) =
            (faces[index].matrix[0][1], faces[index].matrix[1][0], faces[index].matrix[2][1], faces[index].matrix[1][2])
        }
    }
    
    // Запись в пути
    private func writePath(type: FaceType, turn: Turn) {
        let flip: Flip
        switch type {
        case .l:
            flip = turn == Turn.clockwise ? .L : ._L
        case .f:
            flip = turn == Turn.clockwise ? .F : ._F
        case .r:
            flip = turn == Turn.clockwise ? .R : ._R
        case .b:
            flip = turn == Turn.clockwise ? .B : ._B
        case .u:
            flip = turn == Turn.clockwise ? .U : ._U
        case .d:
            flip = turn == Turn.clockwise ? .D : ._D
        }
        self.path.append(flip)
    }

    // Поворот стороны F
    func flipFront(turn: Turn) {
        turnCoordinateNumber(axis: .Z, index: 2, turn: turn)
        turnFace(type: FaceType.f, turn: turn)
        let colorsLeft = (faces[FaceType.l.rawValue].matrix[0][2], faces[FaceType.l.rawValue].matrix[1][2], faces[FaceType.l.rawValue].matrix[2][2])
        if turn == .clockwise {
            (faces[FaceType.l.rawValue].matrix[0][2], faces[FaceType.l.rawValue].matrix[1][2], faces[FaceType.l.rawValue].matrix[2][2]) =
            (faces[FaceType.d.rawValue].matrix[0][0], faces[FaceType.d.rawValue].matrix[0][1], faces[FaceType.d.rawValue].matrix[0][2])

            (faces[FaceType.d.rawValue].matrix[0][0], faces[FaceType.d.rawValue].matrix[0][1], faces[FaceType.d.rawValue].matrix[0][2]) =
            (faces[FaceType.r.rawValue].matrix[2][0], faces[FaceType.r.rawValue].matrix[1][0], faces[FaceType.r.rawValue].matrix[0][0])

            (faces[FaceType.r.rawValue].matrix[2][0], faces[FaceType.r.rawValue].matrix[1][0], faces[FaceType.r.rawValue].matrix[0][0]) =
            (faces[FaceType.u.rawValue].matrix[2][2], faces[FaceType.u.rawValue].matrix[2][1], faces[FaceType.u.rawValue].matrix[2][0])

            (faces[FaceType.u.rawValue].matrix[2][2], faces[FaceType.u.rawValue].matrix[2][1], faces[FaceType.u.rawValue].matrix[2][0]) =
            colorsLeft
        } else {
            (faces[FaceType.l.rawValue].matrix[0][2], faces[FaceType.l.rawValue].matrix[1][2], faces[FaceType.l.rawValue].matrix[2][2]) =
            (faces[FaceType.u.rawValue].matrix[2][2], faces[FaceType.u.rawValue].matrix[2][1], faces[FaceType.u.rawValue].matrix[2][0])

            (faces[FaceType.u.rawValue].matrix[2][2], faces[FaceType.u.rawValue].matrix[2][1], faces[FaceType.u.rawValue].matrix[2][0]) =
            (faces[FaceType.r.rawValue].matrix[2][0], faces[FaceType.r.rawValue].matrix[1][0], faces[FaceType.r.rawValue].matrix[0][0])

            (faces[FaceType.r.rawValue].matrix[2][0], faces[FaceType.r.rawValue].matrix[1][0], faces[FaceType.r.rawValue].matrix[0][0]) =
            (faces[FaceType.d.rawValue].matrix[0][0], faces[FaceType.d.rawValue].matrix[0][1], faces[FaceType.d.rawValue].matrix[0][2])

            (faces[FaceType.d.rawValue].matrix[0][0], faces[FaceType.d.rawValue].matrix[0][1], faces[FaceType.d.rawValue].matrix[0][2]) =
            colorsLeft
        }
    }
    
    // Поворот стороны R
    func flipRight(turn: Turn) {
        turnCoordinateNumber(axis: .X, index: 2, turn: turn)
        turnFace(type: FaceType.r, turn: turn)
        let colorsFront = (faces[FaceType.f.rawValue].matrix[0][2], faces[FaceType.f.rawValue].matrix[1][2], faces[FaceType.f.rawValue].matrix[2][2])
        if turn == .clockwise {
            (faces[FaceType.f.rawValue].matrix[0][2], faces[FaceType.f.rawValue].matrix[1][2], faces[FaceType.f.rawValue].matrix[2][2]) =
            (faces[FaceType.d.rawValue].matrix[0][2], faces[FaceType.d.rawValue].matrix[1][2], faces[FaceType.d.rawValue].matrix[2][2])

            (faces[FaceType.d.rawValue].matrix[0][2], faces[FaceType.d.rawValue].matrix[1][2], faces[FaceType.d.rawValue].matrix[2][2]) =
            (faces[FaceType.b.rawValue].matrix[2][0], faces[FaceType.b.rawValue].matrix[1][0], faces[FaceType.b.rawValue].matrix[0][0])

            (faces[FaceType.b.rawValue].matrix[2][0], faces[FaceType.b.rawValue].matrix[1][0], faces[FaceType.b .rawValue].matrix[0][0]) =
            (faces[FaceType.u.rawValue].matrix[0][2], faces[FaceType.u.rawValue].matrix[1][2], faces[FaceType.u.rawValue].matrix[2][2])

            (faces[FaceType.u.rawValue].matrix[0][2], faces[FaceType.u.rawValue].matrix[1][2], faces[FaceType.u.rawValue].matrix[2][2]) =
            colorsFront
        } else {
            (faces[FaceType.f.rawValue].matrix[0][2], faces[FaceType.f.rawValue].matrix[1][2], faces[FaceType.f.rawValue].matrix[2][2]) =
            (faces[FaceType.u.rawValue].matrix[0][2], faces[FaceType.u.rawValue].matrix[1][2], faces[FaceType.u.rawValue].matrix[2][2])

            (faces[FaceType.u.rawValue].matrix[0][2], faces[FaceType.u.rawValue].matrix[1][2], faces[FaceType.u.rawValue].matrix[2][2])   =
            (faces[FaceType.b.rawValue].matrix[2][0], faces[FaceType.b.rawValue].matrix[1][0], faces[FaceType.b.rawValue].matrix[0][0])

            (faces[FaceType.b.rawValue].matrix[2][0], faces[FaceType.b.rawValue].matrix[1][0], faces[FaceType.b .rawValue].matrix[0][0]) =
            (faces[FaceType.d.rawValue].matrix[0][2], faces[FaceType.d.rawValue].matrix[1][2], faces[FaceType.d.rawValue].matrix[2][2])

            (faces[FaceType.d.rawValue].matrix[0][2], faces[FaceType.d.rawValue].matrix[1][2], faces[FaceType.d.rawValue].matrix[2][2]) =
            colorsFront
        }
    }
    
    // Поворот стороны B
    func flipBack(turn: Turn) {
        turnCoordinateNumber(axis: .Z, index: 0, turn: turn)
        turnFace(type: FaceType.b, turn: turn)
        let colorsRight = (faces[FaceType.r.rawValue].matrix[0][2], faces[FaceType.r.rawValue].matrix[1][2], faces[FaceType.r.rawValue].matrix[2][2])
        if turn == .clockwise {
            (faces[FaceType.r.rawValue].matrix[0][2], faces[FaceType.r.rawValue].matrix[1][2], faces[FaceType.r.rawValue].matrix[2][2]) =
            (faces[FaceType.d.rawValue].matrix[2][2], faces[FaceType.d.rawValue].matrix[2][1], faces[FaceType.d.rawValue].matrix[2][0])

            (faces[FaceType.d.rawValue].matrix[2][2], faces[FaceType.d.rawValue].matrix[2][1], faces[FaceType.d.rawValue].matrix[2][0]) =
            (faces[FaceType.l.rawValue].matrix[2][0], faces[FaceType.l.rawValue].matrix[1][0], faces[FaceType.l.rawValue].matrix[0][0])

            (faces[FaceType.l.rawValue].matrix[2][0], faces[FaceType.l.rawValue].matrix[1][0], faces[FaceType.l.rawValue].matrix[0][0]) =
            (faces[FaceType.u.rawValue].matrix[0][0], faces[FaceType.u.rawValue].matrix[0][1], faces[FaceType.u.rawValue].matrix[0][2])

            (faces[FaceType.u.rawValue].matrix[0][0], faces[FaceType.u.rawValue].matrix[0][1], faces[FaceType.u.rawValue].matrix[0][2]) =
            colorsRight
        } else {
            (faces[FaceType.r.rawValue].matrix[0][2], faces[FaceType.r.rawValue].matrix[1][2], faces[FaceType.r.rawValue].matrix[2][2]) =
            (faces[FaceType.u.rawValue].matrix[0][0], faces[FaceType.u.rawValue].matrix[0][1], faces[FaceType.u.rawValue].matrix[0][2])

            (faces[FaceType.u.rawValue].matrix[0][0], faces[FaceType.u.rawValue].matrix[0][1], faces[FaceType.u.rawValue].matrix[0][2])   =
            (faces[FaceType.l.rawValue].matrix[2][0], faces[FaceType.l.rawValue].matrix[1][0], faces[FaceType.l.rawValue].matrix[0][0])

            (faces[FaceType.l.rawValue].matrix[2][0], faces[FaceType.l.rawValue].matrix[1][0], faces[FaceType.l.rawValue].matrix[0][0]) =
            (faces[FaceType.d.rawValue].matrix[2][2], faces[FaceType.d.rawValue].matrix[2][1], faces[FaceType.d.rawValue].matrix[2][0])

            (faces[FaceType.d.rawValue].matrix[2][2], faces[FaceType.d.rawValue].matrix[2][1], faces[FaceType.d.rawValue].matrix[2][0]) =
            colorsRight
        }
    }
    
    // Поворот стороны L
    func flipLeft(turn: Turn) {
        turnCoordinateNumber(axis: .X, index: 0, turn: turn)
        turnFace(type: FaceType.l, turn: turn)
        let colorsBack = (faces[FaceType.b.rawValue].matrix[0][2], faces[FaceType.b.rawValue].matrix[1][2], faces[FaceType.b.rawValue].matrix[2][2])
        if turn == .clockwise {
            (faces[FaceType.b.rawValue].matrix[0][2], faces[FaceType.b.rawValue].matrix[1][2], faces[FaceType.b.rawValue].matrix[2][2]) =
            (faces[FaceType.d.rawValue].matrix[2][0], faces[FaceType.d.rawValue].matrix[1][0], faces[FaceType.d.rawValue].matrix[0][0])

            (faces[FaceType.d.rawValue].matrix[2][0], faces[FaceType.d.rawValue].matrix[1][0], faces[FaceType.d.rawValue].matrix[0][0]) =
            (faces[FaceType.f.rawValue].matrix[2][0], faces[FaceType.f.rawValue].matrix[1][0], faces[FaceType.f.rawValue].matrix[0][0])

            (faces[FaceType.f.rawValue].matrix[2][0], faces[FaceType.f.rawValue].matrix[1][0], faces[FaceType.f.rawValue].matrix[0][0]) =
            (faces[FaceType.u.rawValue].matrix[2][0], faces[FaceType.u.rawValue].matrix[1][0], faces[FaceType.u.rawValue].matrix[0][0])

            (faces[FaceType.u.rawValue].matrix[2][0], faces[FaceType.u.rawValue].matrix[1][0], faces[FaceType.u.rawValue].matrix[0][0]) =
            colorsBack
        } else {
            (faces[FaceType.b.rawValue].matrix[0][2], faces[FaceType.b.rawValue].matrix[1][2], faces[FaceType.b.rawValue].matrix[2][2]) =
            (faces[FaceType.u.rawValue].matrix[2][0], faces[FaceType.u.rawValue].matrix[1][0], faces[FaceType.u.rawValue].matrix[0][0])

            (faces[FaceType.u.rawValue].matrix[2][0], faces[FaceType.u.rawValue].matrix[1][0], faces[FaceType.u.rawValue].matrix[0][0]) =
            (faces[FaceType.f.rawValue].matrix[2][0], faces[FaceType.f.rawValue].matrix[1][0], faces[FaceType.f.rawValue].matrix[0][0])

            (faces[FaceType.f.rawValue].matrix[2][0], faces[FaceType.f.rawValue].matrix[1][0], faces[FaceType.f.rawValue].matrix[0][0]) =
            (faces[FaceType.d.rawValue].matrix[2][0], faces[FaceType.d.rawValue].matrix[1][0], faces[FaceType.d.rawValue].matrix[0][0])

            (faces[FaceType.d.rawValue].matrix[2][0], faces[FaceType.d.rawValue].matrix[1][0], faces[FaceType.d.rawValue].matrix[0][0]) =
            colorsBack
        }
    }
    
    // Поворот стороны U
    func flipUp(turn: Turn) {
        turnCoordinateNumber(axis: .Y, index: 2, turn: turn)
        turnFace(type: FaceType.u, turn: turn)
        let colorsLeft = (faces[FaceType.l.rawValue].matrix[0][0], faces[FaceType.l.rawValue].matrix[0][1], faces[FaceType.l.rawValue].matrix[0][2])
        if turn == .clockwise {
            (faces[FaceType.l.rawValue].matrix[0][0], faces[FaceType.l.rawValue].matrix[0][1], faces[FaceType.l.rawValue].matrix[0][2]) =
            (faces[FaceType.f.rawValue].matrix[0][0], faces[FaceType.f.rawValue].matrix[0][1], faces[FaceType.f.rawValue].matrix[0][2])

            (faces[FaceType.f.rawValue].matrix[0][0], faces[FaceType.f.rawValue].matrix[0][1], faces[FaceType.f.rawValue].matrix[0][2]) =
            (faces[FaceType.r.rawValue].matrix[0][0], faces[FaceType.r.rawValue].matrix[0][1], faces[FaceType.r.rawValue].matrix[0][2])

            (faces[FaceType.r.rawValue].matrix[0][0], faces[FaceType.r.rawValue].matrix[0][1], faces[FaceType.r.rawValue].matrix[0][2]) =
            (faces[FaceType.b.rawValue].matrix[0][0], faces[FaceType.b.rawValue].matrix[0][1], faces[FaceType.b.rawValue].matrix[0][2])

            (faces[FaceType.b.rawValue].matrix[0][0], faces[FaceType.b.rawValue].matrix[0][1], faces[FaceType.b.rawValue].matrix[0][2]) =
            colorsLeft
        } else {
            (faces[FaceType.l.rawValue].matrix[0][0], faces[FaceType.l.rawValue].matrix[0][1], faces[FaceType.l.rawValue].matrix[0][2]) =
            (faces[FaceType.b.rawValue].matrix[0][0], faces[FaceType.b.rawValue].matrix[0][1], faces[FaceType.b.rawValue].matrix[0][2])

            (faces[FaceType.b.rawValue].matrix[0][0], faces[FaceType.b.rawValue].matrix[0][1], faces[FaceType.b.rawValue].matrix[0][2]) =
            (faces[FaceType.r.rawValue].matrix[0][0], faces[FaceType.r.rawValue].matrix[0][1], faces[FaceType.r.rawValue].matrix[0][2])

            (faces[FaceType.r.rawValue].matrix[0][0], faces[FaceType.r.rawValue].matrix[0][1], faces[FaceType.r.rawValue].matrix[0][2]) =
            (faces[FaceType.f.rawValue].matrix[0][0], faces[FaceType.f.rawValue].matrix[0][1], faces[FaceType.f.rawValue].matrix[0][2])

            (faces[FaceType.f.rawValue].matrix[0][0], faces[FaceType.f.rawValue].matrix[0][1], faces[FaceType.f.rawValue].matrix[0][2]) =
            colorsLeft
        }
    }
    
    // Поворот стороны D
    func flipDown(turn: Turn) {
        turnCoordinateNumber(axis: .Y, index: 0, turn: turn)
        turnFace(type: FaceType.d, turn: turn)
        let colorsLeft = (faces[FaceType.l.rawValue].matrix[2][2], faces[FaceType.l.rawValue].matrix[2][1], faces[FaceType.l.rawValue].matrix[2][0])
        if turn == .clockwise {
            (faces[FaceType.l.rawValue].matrix[2][2], faces[FaceType.l.rawValue].matrix[2][1], faces[FaceType.l.rawValue].matrix[2][0]) =
            (faces[FaceType.b.rawValue].matrix[2][2], faces[FaceType.b.rawValue].matrix[2][1], faces[FaceType.b.rawValue].matrix[2][0])

            (faces[FaceType.b.rawValue].matrix[2][2], faces[FaceType.b.rawValue].matrix[2][1], faces[FaceType.b.rawValue].matrix[2][0]) =
            (faces[FaceType.r.rawValue].matrix[2][2], faces[FaceType.r.rawValue].matrix[2][1], faces[FaceType.r.rawValue].matrix[2][0])

            (faces[FaceType.r.rawValue].matrix[2][2], faces[FaceType.r.rawValue].matrix[2][1], faces[FaceType.r.rawValue].matrix[2][0]) =
            (faces[FaceType.f.rawValue].matrix[2][2], faces[FaceType.f.rawValue].matrix[2][1], faces[FaceType.f.rawValue].matrix[2][0])

            (faces[FaceType.f.rawValue].matrix[2][2], faces[FaceType.f.rawValue].matrix[2][1], faces[FaceType.f.rawValue].matrix[2][0]) =
            colorsLeft
        } else {
            (faces[FaceType.l.rawValue].matrix[2][2], faces[FaceType.l.rawValue].matrix[2][1], faces[FaceType.l.rawValue].matrix[2][0]) =
            (faces[FaceType.f.rawValue].matrix[2][2], faces[FaceType.f.rawValue].matrix[2][1], faces[FaceType.f.rawValue].matrix[2][0])

            (faces[FaceType.f.rawValue].matrix[2][2], faces[FaceType.f.rawValue].matrix[2][1], faces[FaceType.f.rawValue].matrix[2][0]) =
            (faces[FaceType.r.rawValue].matrix[2][2], faces[FaceType.r.rawValue].matrix[2][1], faces[FaceType.r.rawValue].matrix[2][0])

            (faces[FaceType.r.rawValue].matrix[2][2], faces[FaceType.r.rawValue].matrix[2][1], faces[FaceType.r.rawValue].matrix[2][0]) =
            (faces[FaceType.b.rawValue].matrix[2][2], faces[FaceType.b.rawValue].matrix[2][1], faces[FaceType.b.rawValue].matrix[2][0])

            (faces[FaceType.b.rawValue].matrix[2][2], faces[FaceType.b.rawValue].matrix[2][1], faces[FaceType.b.rawValue].matrix[2][0]) =
            colorsLeft
        }
    }
    
    // Вращение указанной грани.
    func flip(_ flip: Flip) {
        switch flip {
        case .L:
            flipLeft(turn: .clockwise)
        case .F:
            flipFront(turn: .clockwise)
        case .R:
            flipRight(turn: .clockwise)
        case .B:
            flipBack(turn: .clockwise)
        case .U:
            flipUp(turn: .clockwise)
        case .D:
            flipDown(turn: .clockwise)
        case ._L:
            flipLeft(turn: .counterclockwise)
        case ._F:
           flipFront(turn: .counterclockwise)
        case ._R:
            flipRight(turn: .counterclockwise)
        case ._B:
            flipBack(turn: .counterclockwise)
        case ._U:
            flipUp(turn: .counterclockwise)
        case ._D:
            flipDown(turn: .counterclockwise)
        }
    }
    
    // Смешивает куб заданное количество раз.
    func mixerRubik(count: Int) -> [Flip] {
        let flips: [Flip] = Flip.allFlips
        var randomFlips = [Flip]()
        for _ in 0..<count {
            randomFlips.append(flips.randomElement()!)
        }
        print(randomFlips)
        for flip in randomFlips {
            self.flip(flip)
        }
        return randomFlips
    }
    
    static func == (lhs: Cube, rhs: Cube) -> Bool {
        return lhs.numbers == rhs.numbers
        //return lhs.faces == rhs.faces
    }
}
