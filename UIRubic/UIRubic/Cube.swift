//
//  Cube.swift
//  UIRubic
//
//  Created by Михаил Фокин on 20.05.2021.
//

import SceneKit

class Cube: Equatable {
    
    var faces = [Face]()
    var f: Int
    var g: Int
    var path: String
    var numbers: [[[Int8]]]
    //var coordinats: [Int8: SCNVector3]
    enum FaceType: Int {
        case l = 0
        case f = 1
        case r = 2
        case b = 3
        case u = 4
        case d = 5
    }
    
    init() {
        let colors: [NSColor] = [.orange, .blue, .red, .green, .yellow, .white]
        let letters = ["L", "F", "R", "B", "U", "D"]
        self.f = 0
        self.path = String()
        self.numbers = Array(repeating: Array(repeating: Array(repeating: Int8(0), count: 3), count: 3), count: 3)
        //self.coordinats = [Int8: SCNVector3]()
        self.g = 0
        fillNumberCube()
        for (color, letter) in zip(colors, letters) {
            self.faces.append(Face(color: color, letter: letter))
        }
    }
    
    // MARK: Конструктор копирования.
    init(cube: Cube) {
        self.faces = cube.faces
        //self.faces = []
        self.f = cube.f
        self.path = cube.path
        self.numbers = cube.numbers
        self.g = cube.g + 1
        //self.coordinats = cube.coordinats
    }
    
    // MARK: Заполнене 3x3x3 массива значениями.
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
    
    // MARK: Вывод граней кубика.
    func printCube() {
        self.faces.forEach({$0.printFace()})
    }
    
    // MARK: Устнавка эвристики.
    func setF(heuristic: Int) {
        //self.f = heuristic + self.g
        self.f = heuristic
    }
    
    // MARK: Печатает куб по слоям.
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
    
    // MARK: Изменение координат номеров. Передается константная ось и костантное значние на этой оси
    private func turnCoordinateNumber(axis: Axis, index: Int, turn: Turn) {
        let numbersCoordinate = getNumber(axis: axis, index: index)
        let turnNumber: (inout CGFloat, inout CGFloat) -> ()
        switch turn {
        case .clockwise:
            turnNumber = turnNumberClockwise
        case .counterclockwise:
            turnNumber = turnNumberСounterclockwise
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
    
    // MARK: Вращение номеров ПО часовой стрелке.
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
    
    // MARK: Вращение номеров ПРОТИВ часовой стрелки.
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
    
    // MARK: Собирает номера и коорлинаты на указанной грани и индексом.
    private func getNumber(axis: Axis, index: Int) -> [(Int8, SCNVector3)] {
        var numbers = [(Int8, SCNVector3)]()
        for a in 0...2 {
            for b in 0...2 {
                numbers.append(getNumberCoordinate(a, b, axis: axis, index: index))
            }
        }
        return numbers
    }
    
    // MARK: Возвращает номер и координату номера.
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
    
    // MARK: Вращение грани ПО или ПРОТИВ часовой стрелки гранией кубика.
    private func turnFace(index: Int, turn: Turn) {
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
    
    // MARK: Поворот стороны F
    func flipFront(turn: Turn) {
        turnCoordinateNumber(axis: .Z, index: 2, turn: turn)
        turnFace(index: FaceType.f.rawValue, turn: turn)
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
    
    // MARK: Поворот стороны R
    func flipRight(turn: Turn) {
        turnCoordinateNumber(axis: .X, index: 2, turn: turn)
        turnFace(index: FaceType.r.rawValue, turn: turn)
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
    
    // MARK: Поворот стороны B
    func flipBack(turn: Turn) {
        turnCoordinateNumber(axis: .Z, index: 0, turn: turn)
        turnFace(index: FaceType.b.rawValue, turn: turn)
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
    
    // MARK: Поворот стороны L
    func flipLeft(turn: Turn) {
        turnCoordinateNumber(axis: .X, index: 0, turn: turn)
        turnFace(index: FaceType.l.rawValue, turn: turn)
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
    
    // MARK: Поворот стороны U
    func flipUp(turn: Turn) {
        turnCoordinateNumber(axis: .Y, index: 2, turn: turn)
        turnFace(index: FaceType.u.rawValue, turn: turn)
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
    
    // MARK: Поворот стороны D
    func flipDown(turn: Turn) {
        turnCoordinateNumber(axis: .Y, index: 0, turn: turn)
        turnFace(index: FaceType.d.rawValue, turn: turn)
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
    
    static func == (lhs: Cube, rhs: Cube) -> Bool {
        return lhs.numbers == rhs.numbers
        //return lhs.faces == rhs.faces
    }
}
