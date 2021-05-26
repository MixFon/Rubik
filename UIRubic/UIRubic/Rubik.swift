//
//  Pazzle.swift
//  N_Puzzle
//
//  Created by Михаил Фокин on 21.04.2021.
//

import Foundation

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
        if self.cube == self.cubeTarget {
            return self.cube!
        }
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
            newCube.path.append(flip)
            let heuristic = self.heuristic!.getHeuristic(cube: newCube, coordinateTarget: self.coordinatsTarget)
            newCube.setF(heuristic: heuristic)
            if !self.close.contains(newCube.numbers.hashValue) {
                childrens.append(newCube)
            }
        }
        return childrens
    }
    
    // MARK: Первый шаг, првильный крест.
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
    
    
    func mixerRubik(count: Int) {
        let flips = ["L", "F", "R", "B", "U", "D", "L'", "F'", "R'", "B'", "U'", "D'"]
        var randomFlips = [String]()
        for _ in 0..<count {
            randomFlips.append(flips.randomElement()!)
        }
        print(randomFlips)
        for flip in randomFlips {
            switch flip {
            case "L":
                self.cube?.flipLeft(turn: .clockwise)
            case "F":
                self.cube?.flipFront(turn: .clockwise)
            case "R":
                self.cube?.flipRight(turn: .clockwise)
            case "B":
                self.cube?.flipBack(turn: .clockwise)
            case "U":
                self.cube?.flipUp(turn: .clockwise)
            case "D":
                self.cube?.flipDown(turn: .clockwise)
            case "L'":
                self.cube?.flipLeft(turn: .counterclockwise)
            case "F'":
                self.cube?.flipFront(turn: .counterclockwise)
            case "R'":
                self.cube?.flipRight(turn: .counterclockwise)
            case "B'":
                self.cube?.flipBack(turn: .counterclockwise)
            case "U'":
                self.cube?.flipUp(turn: .counterclockwise)
            case "D'":
                self.cube?.flipDown(turn: .counterclockwise)
            default:
                print("error")
                continue
            }
        }
    }
}
