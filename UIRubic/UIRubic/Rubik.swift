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
    var close: Set<Int>
    
    init() {
        self.heuristic = .manhattan
        self.cubeTarget = Cube()
        self.cube = Cube()
        self.close = Set<Int>()
    }
    
    // MARK: Поиск решения, используя алгоритм A*. Стоит ограничение на 2*10^6 проссмотренных узлов.
    func searchSolutionWithHeap() -> Cube {
        if self.cube == self.cubeTarget {
            return self.cube!
        }
        let heap = Heap()
        var complexityTime = 0
        //self.cube!.setF(heuristic: self.heuristic!.getHeuristic(coordinats: self.board!.coordinats, coordinatsTarget: self.cubeTarget!.coordinats))
        heap.push(cube: self.cube!)
        while !heap.isEmpty() {
            let cube = heap.pop()
            //let neighbors = cube.getNeighbors(number: 0)
            let children = getChildrens(cube: cube)
            for cube in children {
                if cube == self.cubeTarget! {
                    return cube
                }
                heap.push(cube: cube)
                complexityTime += 1
            }
            self.close.insert(cube.faces.hashValue)
        }
        print("The Pazzle has no solution.")
        return Cube()
    }
    
    // MARK: Возвращает список смежных состояний.
    private func getChildrens(cube: Cube) -> [Cube] {
        var childrens = [Cube]()
//        for number in neighbors {
//            let newCube = Cube(cube: cube)
//            newBoard.addDirection(numberFrom: number, numberTo: 0)
//            newBoard.swapNumber(numberFrom: number, numberTo: 0)
//            let heuristic = self.heuristic!.getHeuristic(coordinats: newBoard.coordinats, coordinatsTarget: self.boardTarget!.coordinats)
//            newBoard.setF(heuristic: heuristic)
//            if !self.close.contains(newCube.faces.hashValue) {
//                childrens.append(newCube)
//            }
//        }
        return childrens
    }
}
