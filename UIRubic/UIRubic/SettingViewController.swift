//
//  SettingViewController.swift
//  UIRubik
//
//  Created by Михаил Фокин on 04.06.2021.
//

import Cocoa

class SettingViewController: NSViewController {
    
    weak var gameVC: GameViewController?

    @IBOutlet weak var stepper: NSStepper!
    @IBOutlet weak var lableStepper: NSTextField!
    @IBOutlet weak var multiLable: NSTextField!
    @IBOutlet weak var textFild: NSTextField!
    
    @IBAction func pressStepper(_ sender: NSStepper) {
        lableStepper.stringValue = sender.stringValue
    }
    
    @IBAction func pressRead(_ sender: NSButton) {
        let flips = textFild.stringValue
        if flips.isEmpty { return }
        guard let cube = try? Cube(argument: flips) else {
            multiLable.textColor = .red
            multiLable.stringValue = "Invalid data."
            return
        }
        gameVC?.stepsNext = cube.path
        gameVC?.stepsPrevious = []
        multiLable.stringValue.removeAll()
    }
    
    @IBAction func pressGenerate(_ sender: NSButton) {
        let count = stepper.intValue
        textFild.stringValue = generateRandomFlips(count: Int(count))
    }
    
    @IBAction func pressSolution(_ sender: NSButton) {
        guard let cube = gameVC?.cube else { return }
        let solution = Solution(cube: Cube(cube: cube))
        let solutionCube = solution.solution()
        multiLable.textColor = .green
        multiLable.stringValue = solutionCube.getPathString()
        gameVC?.stepsNext = solutionCube.path
        gameVC?.stepsPrevious = []
    }
    
    private func generateRandomFlips(count: Int) -> String {
        var result = String()
        let elements = ["L", "F", "R", "B", "U", "D",
                        "L'", "F'", "R'", "B'", "U'", "D'",
                        "L2", "F2", "R2", "B2", "U2", "D2"]
        for _ in 0...count {
            result += "\(elements.randomElement()!) "
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lableStepper.stringValue = stepper.stringValue
    }
    
}
