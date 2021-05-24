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
    var path: String
    
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
        for (color, letter) in zip(colors, letters) {
            self.faces.append(Face(color: color, letter: letter))
        }
    }
    
    // MARK: Конструктор копирования.
    init(cube: Cube) {
        self.faces = cube.faces
        self.f = cube.f
        self.path = cube.path
    }
    
    func printCube() {
        self.faces.forEach({$0.printFace()})
    }
    
    func setF(heuristic: Int) {
        self.f = heuristic
    }
    
    // MARK: Вращение грани ПО или ПРОТИВ часовой стрелки.
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
        return lhs.faces == rhs.faces
    }
}
