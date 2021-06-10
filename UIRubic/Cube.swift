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
    
    convenience init(argument: String) throws {
        self.init()
        let flips = try parserArgument(argument: argument)
        let flipsFlip = getFlipsFromArrString(arrFlips: flips)
        for flip in flipsFlip {
            self.flip(flip)
        }
    }
    
    // Конструктор копирования.
    init(cube: Cube) {
        for face in cube.faces {
            self.faces.append(face)
        }
        self.f = cube.f
        self.path = cube.path
        self.numbers = cube.numbers
        self.g = cube.g + 1
    }
    
    // Переводит массив поворотов строк в массив поворотов (Flip)
    private func getFlipsFromArrString(arrFlips: [String]) -> [Flip] {
        var flips = [Flip]()
        for element in arrFlips {
            let flip: Flip?
            switch element {
            case "L":
                flip = .L
            case "F":
                flip = .F
            case "R":
                flip = .R
            case "B":
                flip = .B
            case "U":
                flip = .U
            case "D":
                flip = .D
            case "L'":
                flip = ._L
            case "F'":
                flip = ._F
            case "R'":
                flip = ._R
            case "B'":
                flip = ._B
            case "U'":
                flip = ._U
            case "D'":
                flip = ._D
            default:
                flip = nil
            }
            if let temp = flip {
                flips.append(temp)
            } else {
                print("Error flips in Cube.")
                return []
            }
        }
        return flips
    }
    
    // Печатает путь на поток вывода.
    func printPath() {
        for flip in getPath() {
            print(flip, terminator: " ")
        }
        print()
    }
    
    // Возвращает решение головоломки в виде одной строки.
    func getPathString() -> String {
        var result = String()
        for flip in getPath() {
            result += flip + " "
        }
        result += "\n"
        return result
    }
    
    // Возвращает последовательность спинов в виде массива строк
    func getPath() -> [String] {
        var result = [String]()
        var i = 0
        while i < self.path.count {
            let count = countFlips(iter: i)
            if count == 2 && self.path[i].rawValue.count == 1 {
                result.append("\(self.path[i].rawValue)2")
                i += count
                continue
            } else if count == 3 && self.path[i].rawValue.count == 1 {
                result.append("\(self.path[i].rawValue)'")
                i += count
                continue
            } else if count == 4 && self.path[i].rawValue.count == 1 {
                i += count
                continue
            } else {
                result.append(self.path[i].rawValue)
            }
            i += 1
        }
        return result
    }
    
    // Подсчет одинаковых поворотов.
    private func countFlips(iter: Int) -> Int {
        var i = iter
        let flip = self.path[iter]
        while i < self.path.count && flip == self.path[i] {
            i += 1
        }
        return i - iter
    }
    
    // Заполнене 3x3x3 массива значениями.
    private func fillNumberCube() {
        var elem: Int8 = 0
        for i in 0...2 {
            for j in 0...2 {
                for k in 0...2 {
                    self.numbers[i][j][k] = elem
                    elem += 1
                }
            }
        }
    }
    
    // Обрабатывает аргумент (строковую последовательность спинов)
    private func parserArgument(argument: String) throws -> [String] {
        let flips = argument.split{ $0 == " " }.map( {String($0)} )
        for flip in flips {
            if flip.count == 1 {
                try checkFlip(flip: flip)
            } else if flip.count == 2 {
                try checkFlip(flip: String(flip.first!))
                if !"'2".contains(flip.last!) {
                    throw Exception(massage: "Invalid argument: \(flip)")
                }
            } else {
                throw Exception(massage: "Invalid argument: \(flip)")
            }
        }
        return parserArraySteps(steps: flips)
    }
    
    // Преобразует входную последовательность поворотов (заменяя F2 на F F)
    private func parserArraySteps(steps: [String]) -> [String] {
        var result = [String]()
        for step in steps {
            if step.count == 2 {
                if step.last == "2" {
                    if let first = step.first {
                        result.append(String(first))
                        result.append(String(first))
                        continue
                    }
                }
            }
            result.append(step)
        }
        return result
    }
    
    // Проверка на допустимые символы. Допустимы только L F R B U D
    private func checkFlip(flip: String) throws {
        if !"LFRBUD".contains(flip) {
            throw Exception(massage: "Invalid argument: \(flip)")
        }
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
    
    func getFase(type: FaceType) -> Face {
        switch type {
        case .l:
            return self.faces[0]
        case .f:
            return self.faces[1]
        case .r:
            return self.faces[2]
        case .b:
            return self.faces[3]
        case .u:
            return self.faces[4]
        case .d:
            return self.faces[5]
        }
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
    
    // Запись поворотов в массив решения
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
        for flip in randomFlips {
            self.flip(flip)
        }
        return randomFlips
    }
    
    static func == (lhs: Cube, rhs: Cube) -> Bool {
        for (left, right) in zip(lhs.faces, rhs.faces) {
            if left.matrix != right.matrix {
                return false
            }
        }
        return true
    }
}
