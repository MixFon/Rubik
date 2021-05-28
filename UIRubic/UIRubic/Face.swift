//
//  Face.swift
//  UIRubic
//
//  Created by Михаил Фокин on 24.05.2021.
//

import SceneKit

struct Face: Hashable {
    
    let color: Color
    let flip: Flip
    var matrix: [[Color]]
    let index: Int
    
//    var left: Face?
//    var right: Face?
//    var up: Face?
//    var down: Face?
    
    init(color: Color, flip: Flip, index: Int) {
        self.color = color
        self.flip = flip
        self.index = index
        self.matrix = Array(repeating: Array(repeating: color, count: 3), count: 3)
    }
    
    init(face: Face) {
        self.color = face.color
        self.flip = face.flip
        self.matrix = face.matrix
        self.index = face.index
    }
    
    func printFace() {
        for row in matrix {
            for elem in row {
                let put: String
                switch elem {
                case .orange:
                    put = "L"
                case .blue:
                    put = "F"
                case .red:
                    put = "R"
                case .green:
                    put = "B"
                case .yellow:
                    put = "U"
                case .white:
                    put = "D"
                }
                print(put, terminator: " ")
            }
            print()
        }
        print()
    }
    
    static func == (lhs: Face, rhs: Face) -> Bool {
        return true
    }
}

