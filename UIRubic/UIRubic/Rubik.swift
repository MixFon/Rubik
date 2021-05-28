//
//  Pazzle.swift
//  N_Puzzle
//
//  Created by Михаил Фокин on 21.04.2021.
//

import Foundation
import SceneKit

class Rubik {
    
    var heuristic: Heuristic?
    var cubeTarget: Cube?
    var cube: Cube?
    var coordinatsTarget = [Int8: Coordinate]()
    var close: Set<Int>
    
    init() {
        self.heuristic = .manhattan
        self.cubeTarget = Cube()
        self.cube = Cube()
        self.close = Set<Int>()
        self.coordinatsTarget = getCoordinateTarger()
    }
    
    // MARK: Возвращает координаты куба для вычисления Эвристики Манхеттена
    private func getCoordinateTarger() -> [Int8: Coordinate] {
        var iter: Int8 = 0
        var numberCoordinats = [Int8: Coordinate]()
        for i in 0...2 {
            for j in 0...2 {
                for k in 0...2 {
                    let coordinate = Coordinate(x: i, y: j, z: k)
                    numberCoordinats[iter] = coordinate
                    iter += 1
                }
            }
        }
        return numberCoordinats
    }
    
    // MARK: Поиск решения, используя алгоритм A*. Стоит ограничение на 2*10^6 проссмотренных узлов.
    func searchSolutionWithHeap() -> Cube {
//        if self.cube == self.cubeTarget {
//            return self.cube!
//        }
        let heap = Heap()
        var complexityTime = 0
        let heuristic = self.heuristic!.getHeuristic(cube: self.cube!, coordinateTarget: self.coordinatsTarget)
        self.cube!.setF(heuristic: heuristic)
        heap.push(cube: self.cube!)
        while !heap.isEmpty() {
            let cube = heap.pop()
            let children = getChildrens(cube: cube)
            for cube in children {
                if threeStep(cube: cube) {
                    //locationSeven(cube: cube)
                    //cross(cube: cube)
                    print("Solve!")
                    return cube
                }
                heap.push(cube: cube)
                complexityTime += 1
            }
            self.close.insert(cube.numbers.hashValue)
        }
        print("The Pazzle has no solution.")
        return Cube()
    }
    
    // MARK: Грань F
    private func isFaceF(cube: Cube) -> Bool {
        return
            cube.faces[1].matrix[0][0] == NSColor.blue &&
            cube.faces[1].matrix[1][0] == NSColor.blue &&
            cube.faces[1].matrix[2][0] == NSColor.blue &&
            cube.faces[1].matrix[2][1] == NSColor.blue &&
            cube.faces[1].matrix[2][2] == NSColor.blue &&
            cube.faces[1].matrix[1][2] == NSColor.blue &&
            cube.faces[1].matrix[0][2] == NSColor.blue &&
            cube.faces[1].matrix[0][1] == NSColor.blue
    }
    
    // MARK: Крутим указанное число на правое место в координиту [2][2][1].
    private func moveLocationRight(cube: Cube, number: Int8) {
        while cube.numbers[2][2][1] != number {
            cube.flipUp(turn: .clockwise)
        }
    }
    
    // MARK: Создание правильного креста.
    private func cross(cube: Cube) {
        if isCross(cube: cube) {
            return
        }
        if let number = inNearby(cube: cube) {
            print("Nearby")
            moveLocationRight(cube: cube, number: number)
            caseNearby(cube: cube)
        } else {
            // Возможно в дальнейшем можно будет убрать.
            print("Opposite")
            caseOpposite(cube: cube)
            //cross(cube: cube)
        }
        moveLocationRight(cube: cube, number: 25)
    }
    
    private func inNearby(cube: Cube) -> Int8? {
        if isNeighbors(left: cube.numbers[0][2][1], rigth: cube.numbers[1][2][2]) {
            return cube.numbers[0][2][1]
        } else if isNeighbors(left: cube.numbers[1][2][2], rigth: cube.numbers[2][2][1]) {
            return cube.numbers[1][2][2]
        } else if isNeighbors(left: cube.numbers[2][2][1], rigth: cube.numbers[1][2][0]) {
            return cube.numbers[2][2][1]
        } else if isNeighbors(left: cube.numbers[1][2][0], rigth: cube.numbers[0][2][1]) {
            return cube.numbers[1][2][0]
        }
        return nil
    }
    
    // MARK: Проверяет являются ли два поданных числа соседними.
    private func isNeighbors(left: Int8, rigth: Int8) -> Bool {
        switch left {
        case 7:
            return rigth == 17
        case 17:
            return rigth == 25
        case 25:
            return rigth == 15
        case 15:
            return rigth == 7
        default:
            return false
        }
    }
    
    // MARK: Комбинация для случая "Рядом"
    private func caseNearby(cube: Cube) {
        cube.flipRight(turn: .clockwise)        // R
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .counterclockwise) // R'
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .clockwise)        // R
        cube.flipUp(turn: .clockwise)           // U
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .counterclockwise) // R'
        cube.flipUp(turn: .clockwise)           // U
    }
    
    // MARK: Комбинация для случая "Напротив"
    private func caseOpposite(cube: Cube) {
        cube.flipRight(turn: .clockwise)        // R
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .counterclockwise) // R'
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .clockwise)        // R
        cube.flipUp(turn: .clockwise)           // U
        cube.flipUp(turn: .clockwise)           // U
        cube.flipRight(turn: .counterclockwise) // R'
    }
    
    // MARK: Проверяет получился ли крест.
    private func isCross(cube: Cube) -> Bool {
        return
            cube.numbers[0][2][1] == 7 &&
            cube.numbers[2][2][1] == 25 &&
            cube.numbers[1][2][0] == 15 &&
            cube.numbers[1][2][2] == 17
    }
    
    // MARK: Возвращает список смежных состояний.
    private func getChildrens(cube: Cube) -> [Cube] {
        var childrens = [Cube]()
        let flips = ["L", "F", "R", "B", "U", "D", "L'", "F'", "R'", "B'", "U'", "D'"]
//        if cube.g > 6 {
//            return []
//        }
        //print(cube.g)
        for flip in flips {
            let newCube = Cube(cube: cube)
            switch flip {
            case "L":
                newCube.flipLeft(turn: .clockwise)
            case "F":
                newCube.flipFront(turn: .clockwise)
            case "R":
                newCube.flipRight(turn: .clockwise)
            case "B":
                newCube.flipBack(turn: .clockwise)
            case "U":
                newCube.flipUp(turn: .clockwise)
            case "D":
                newCube.flipDown(turn: .clockwise)
            case "L'":
                newCube.flipLeft(turn: .counterclockwise)
            case "F'":
                newCube.flipFront(turn: .counterclockwise)
            case "R'":
                newCube.flipRight(turn: .counterclockwise)
            case "B'":
                newCube.flipBack(turn: .counterclockwise)
            case "U'":
                newCube.flipUp(turn: .counterclockwise)
            case "D'":
                newCube.flipDown(turn: .counterclockwise)
            default:
                continue
            }
            //newCube.path.append(flip)
            let heuristic = self.heuristic!.getHeuristic(cube: newCube, coordinateTarget: self.coordinatsTarget)
            newCube.setF(heuristic: heuristic)
            if !self.close.contains(newCube.numbers.hashValue) {
                childrens.append(newCube)
            }
        }
        return childrens
    }
    
    // MARK: Первый шаг, правильный крест.
    private func fitstStep(cube: Cube) -> Bool {
        return
            cube.numbers[0][0][1] == 1 &&
            cube.numbers[1][0][1] == 10 &&
            cube.numbers[2][0][1] == 19 &&
            cube.numbers[1][0][0] == 9 &&
            cube.numbers[1][0][2] == 11 &&
            cube.numbers[0][1][1] == 4 &&
            cube.numbers[2][1][1] == 22 &&
            cube.numbers[1][1][0] == 12 &&
            cube.numbers[1][1][2] == 14
    }
    
    // MARK: Второй шаг, углы первого слоя.
    private func secondStep(cube: Cube) -> Bool {
        return
            cube.numbers[0][0][1] == 1 &&
            cube.numbers[1][0][1] == 10 &&
            cube.numbers[2][0][1] == 19 &&
            cube.numbers[1][0][0] == 9 &&
            cube.numbers[1][0][2] == 11 &&
            
            cube.numbers[0][0][0] == 0 &&
            cube.numbers[2][0][0] == 18 &&
            cube.numbers[2][0][2] == 20 &&
            cube.numbers[0][0][2] == 2 &&
            
            cube.numbers[0][1][1] == 4 &&
            cube.numbers[2][1][1] == 22 &&
            cube.numbers[1][1][0] == 12 &&
            cube.numbers[1][1][2] == 14
    }
    
    // MARK: Третий шаг, ребра среднего слоя.
    private func threeStep(cube: Cube) -> Bool {
        return
            cube.numbers[0][0][1] == 1 &&
            cube.numbers[1][0][1] == 10 &&
            cube.numbers[2][0][1] == 19 &&
            cube.numbers[1][0][0] == 9 &&
            cube.numbers[1][0][2] == 11 &&
            
            cube.numbers[0][0][0] == 0 &&
            cube.numbers[2][0][0] == 18 &&
            cube.numbers[2][0][2] == 20 &&
            cube.numbers[0][0][2] == 2 &&
            
            cube.numbers[0][1][1] == 4 &&
            cube.numbers[2][1][1] == 22 &&
            cube.numbers[1][1][0] == 12 &&
            cube.numbers[1][1][2] == 14 &&
        
            cube.numbers[0][1][0] == 3 &&
            cube.numbers[2][1][0] == 21 &&
            cube.numbers[2][1][2] == 23 &&
            cube.numbers[0][1][2] == 5
    }
    
    // MARK: Четвертый-пятый шаг, правильный крест в последнем слое..
    private func fourStep(cube: Cube) -> Bool {
        return
            cube.numbers[0][0][1] == 1 &&
            cube.numbers[1][0][1] == 10 &&
            cube.numbers[2][0][1] == 19 &&
            cube.numbers[1][0][0] == 9 &&
            cube.numbers[1][0][2] == 11 &&
            
            cube.numbers[0][0][0] == 0 &&
            cube.numbers[2][0][0] == 18 &&
            cube.numbers[2][0][2] == 20 &&
            cube.numbers[0][0][2] == 2 &&
            
            cube.numbers[0][1][1] == 4 &&
            cube.numbers[2][1][1] == 22 &&
            cube.numbers[1][1][0] == 12 &&
            cube.numbers[1][1][2] == 14 &&
        
            cube.numbers[0][1][0] == 3 &&
            cube.numbers[2][1][0] == 21 &&
            cube.numbers[2][1][2] == 23 &&
            cube.numbers[0][1][2] == 5 &&
        
            // верхный слой, крест
            cube.numbers[0][2][1] == 7 &&
            cube.numbers[2][2][1] == 25 &&
            cube.numbers[1][2][0] == 15 &&
            cube.numbers[1][2][2] == 17
    }
    
    // MARK: Финальный шаг, полная сборка.
    private func finalStep(cube: Cube) -> Bool {
        return
            cube.numbers[0][0][1] == 1 &&
            cube.numbers[1][0][1] == 10 &&
            cube.numbers[2][0][1] == 19 &&
            cube.numbers[1][0][0] == 9 &&
            cube.numbers[1][0][2] == 11 &&
            
            cube.numbers[0][0][0] == 0 &&
            cube.numbers[2][0][0] == 18 &&
            cube.numbers[2][0][2] == 20 &&
            cube.numbers[0][0][2] == 2 &&
            
            cube.numbers[0][1][1] == 4 &&
            cube.numbers[2][1][1] == 22 &&
            cube.numbers[1][1][0] == 12 &&
            cube.numbers[1][1][2] == 14 &&
        
            cube.numbers[0][1][0] == 3 &&
            cube.numbers[2][1][0] == 21 &&
            cube.numbers[2][1][2] == 23 &&
            cube.numbers[0][1][2] == 5 &&
        
            // верхный слой, крест
            cube.numbers[0][2][1] == 7 &&
            cube.numbers[2][2][1] == 25 &&
            cube.numbers[1][2][0] == 15 &&
            cube.numbers[1][2][2] == 17 &&
        
            cube.numbers[0][2][0] == 6 &&
            cube.numbers[2][2][0] == 24 &&
            cube.numbers[2][2][2] == 26 &&
            cube.numbers[0][2][2] == 8
    }
}
