//
//  Rubik.swift
//  Rubik
//
//  Created by Михаил Фокин on 02.06.2021.
//

import Foundation

class Rubik {
    
    func run() {
        if CommandLine.arguments.count != 2 {
            systemError(massage: "Invalid number of arguments.")
        }
        let argument = CommandLine.arguments.last!.uppercased()
        if argument.isEmpty {
            systemError(massage: "Empty argument.")
        }
        do {
            let cube = try Cube(argument: argument)
            let solution = Solution(cube: cube)
            let solutionCube = solution.solution()
            solutionCube.printPath()
        } catch let exception as Exception {
            systemError(massage: exception.massage)
        } catch {}
    }
    
    
    // Вывод сообщения об ошибке в поток ошибок
    private func systemError(massage: String) {
        fputs(massage + "\n", stderr)
        exit(-1)
    }
}
