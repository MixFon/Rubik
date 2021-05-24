//
//  Face.swift
//  UIRubic
//
//  Created by Михаил Фокин on 24.05.2021.
//

import SceneKit

struct Face: Hashable {
    
    let color: NSColor
    let letter: String
    var matrix: [[NSColor]]
    
//    var left: Face?
//    var right: Face?
//    var up: Face?
//    var down: Face?
    
    init(color: NSColor, letter: String) {
        self.color = color
        self.letter = letter
        self.matrix = Array(repeating: Array(repeating: color, count: 3), count: 3)
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
                case .orange:
                    put = "L"
                case .red:
                    put = "R"
                case .green:
                    put = "B"
                case .yellow:
                    put = "U"
                case .white:
                    put = "D"
                default:
                    put = "*"
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

