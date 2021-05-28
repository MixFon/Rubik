//
//  GameViewController.swift
//  UIRubic
//
//  Created by Михаил Фокин on 20.05.2021.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    var central = SCNNode()
    var boxGreen = SCNNode()
    var boxRed = SCNNode()
    var boxBlue = SCNNode()
    var scene: SCNScene?
    let delta = 4
    
    var stepsNext: [Flip]?
    var stepsPrevious: [Flip]?
    var solutionPath = [Flip]()
    
    let duration: TimeInterval = 0.1
    
//    var actions = [SCNAction]()
//    var seqeusence = SCNAction()
    
    var cube = Cube()
    
    var flag = true
    
    enum Key: UInt16 {
        case Key_J = 38         // D
        case Key_K = 40         // D'
        case Key_L = 37         // R
        case Key_Semicolon = 41 // R'
        case Key_A = 0          // L
        case Key_S = 1          // L'
        case Key_D = 2          // U
        case Key_F = 3          // U'
        case Key_Z = 6          // F
        case Key_X = 7          // F'
        case Key_C = 8          // B
        case Key_V = 9          // B'
        case Key_Q = 12         // Next step
        case Key_W = 13         // Prev step
        case Key_R = 15         // Calculate path
        case Key_T = 17         // switch path solution
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        self.scene = SCNScene(named: "art.scnassets/ship.scn")
        guard let scene = self.scene else { return }
        
        addEvents()
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 50, z: 50)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        //addCube()
        addCubeFromCube()
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    // MARK: Преобразует входную последовательность поворотов (заменяя F2 на F F)
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
    
    // MARK: Добавлние обработку событий.
    private func addEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
               return nil
            } else {
               return $0
            }
         }
    }
    
    // MARK: Обработка событий нажатий клавиш
    private func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
        NSApplication.shared.keyWindow === locWindow else { return false }
        //print(event.keyCode)
        switch event.keyCode {
        case Key.Key_A.rawValue:
            moveNodesCube(flip: .L)
        case Key.Key_S.rawValue:
            moveNodesCube(flip: ._L)
        case Key.Key_D.rawValue:
            moveNodesCube(flip: .U)
        case Key.Key_F.rawValue:
            moveNodesCube(flip: ._U)
        case Key.Key_J.rawValue:
            moveNodesCube(flip: .D)
        case Key.Key_K.rawValue:
            moveNodesCube(flip: ._D)
        case Key.Key_L.rawValue:
            moveNodesCube(flip: .R)
        case Key.Key_Semicolon.rawValue:
            moveNodesCube(flip: ._R)
        case Key.Key_Z.rawValue:
            moveNodesCube(flip: .F)
        case Key.Key_X.rawValue:
            moveNodesCube(flip: ._F)
        case Key.Key_C.rawValue:
            moveNodesCube(flip: .B)
        case Key.Key_V.rawValue:
            moveNodesCube(flip: ._B)
        case Key.Key_Q.rawValue:
            stepNext()
        case Key.Key_W.rawValue:
            stepPrevious()
        case Key.Key_R.rawValue:
            findSolution()
        case Key.Key_T.rawValue:
            self.stepsNext = self.solutionPath
            self.stepsPrevious = []
        default:
            return false
        }
        return true
    }
    
    // MARK: В зависимости от команды производит вращение nods
    private func moveNodesCube(flip: Flip) {
        usleep(useconds_t(1000000 * self.duration + 50000))
        var axis: Axis
        var turn: Turn
        (axis, turn) = (.X, .clockwise)
        switch flip {
        case .L:
            (axis, turn) = (.X, .clockwise)
           // self.cube.flipLeft(turn: .clockwise)
        case ._L:
            (axis, turn) = (.X, .counterclockwise)
           // self.cube.flipLeft(turn: .counterclockwise)
        case .U:
            (axis, turn) = (.Y, .counterclockwise)           // Изменил для вращения по часам. Для противоположных граней.
            //self.cube.flipUp(turn: .clockwise)
        case ._U:
            (axis, turn) = (.Y, .clockwise)                 // Изменил для вращения по часам. Для противоположных граней.
           // self.cube.flipUp(turn: .counterclockwise)
        case .D:
            (axis, turn) = (.Y, .clockwise)
            //self.cube.flipDown(turn: .clockwise)
        case ._D:
            (axis, turn) = (.Y, .counterclockwise)
           // self.cube.flipDown(turn: .counterclockwise)
        case .R:
            (axis, turn) = (.X, .counterclockwise)          // Изменил для вращения по часам. Для противоположных граней.
            //self.cube.flipRight(turn: .clockwise)
        case ._R:
            (axis, turn) = (.X, .clockwise)                 // Изменил для вращения по часам. Для противоположных граней.
            //self.cube.flipRight(turn: .counterclockwise)
        case .F:
            (axis, turn) = (.Z, .counterclockwise)          // Изменил для вращения по часам. Для противоположных граней.
            //self.cube.flipFront(turn: .clockwise)
        case ._F:
            (axis, turn) = (.Z, .clockwise)                 // Изменил для вращения по часам. Для противоположных граней.
            //self.cube.flipFront(turn: .counterclockwise)
        case .B:
            (axis, turn) = (.Z, .clockwise)
            //self.cube.flipBack(turn: .clockwise)
        case ._B:
            (axis, turn) = (.Z, .counterclockwise)
            //self.cube.flipBack(turn: .counterclockwise)
        }
        self.cube.flip(flip)
        moveFromNumbers(axis: axis, turn: turn)
    }
    
    // MARK: Перемещение по коодинатам куба.
    private func moveFromNumbers(axis: Axis, turn: Turn) {
        let angle: CGFloat
        var positionAxis: SCNVector3
        var rotate: SCNAction
        if turn == .clockwise {
            angle = .pi / 2
        } else {
            angle = -.pi / 2
        }
        switch axis {
        case .X:
            rotate = SCNAction.rotateBy(x: angle, y: 0, z: 0, duration: self.duration)
            positionAxis = SCNVector3(1, 0, 0)
        case .Y:
            rotate = SCNAction.rotateBy(x: 0, y: angle, z: 0, duration: self.duration)
            positionAxis = SCNVector3(0, 1, 0)
        case .Z:
            rotate = SCNAction.rotateBy(x: 0, y: 0, z: angle, duration: self.duration)
            positionAxis = SCNVector3(0, 0, 1)
        }
        for i in 0...2 {
            for j in 0...2 {
                for k in 0...2 {
                    let name = "\(self.cube.numbers[i][j][k])"
                    guard let node = self.scene?.rootNode.childNode(withName: name, recursively: false) else {
                        print("error")
                        return
                    }
                    let position = SCNVector3(i * self.delta, j * self.delta, k * self.delta)
                    if position == node.position {
                        continue
                    }
                    let move = SCNAction.move(to: position, duration: self.duration)
                    move.timingMode = .easeInEaseOut
                    rotate = SCNAction.rotate(by: angle, around: positionAxis, duration: self.duration)
                   
                    rotate.timingMode = .easeInEaseOut
                    let moveRotate = SCNAction.group([move, rotate])
                    node.runAction(moveRotate)
                }
            }
        }
    }
    
    // MARK: Поиск решения.
    private func findSolution() {
        resetCube()
        let cube = Cube()
        self.stepsNext = cube.mixerRubik(count: 15)
        self.stepsPrevious = []
        let solurion = Solution(cube: cube)
        print("Run")
        let solve = solurion.solution()
        self.solutionPath = solve.path
        //print(solve.path)
        solve.printLayers()
        solve.printCube()
    }
    
    // MARK: Шаг вперед.
    private func stepNext() {
        if self.stepsNext == nil { return }
        if self.stepsNext!.isEmpty { return }
        guard let flip = self.stepsNext?.removeFirst() else { return }
        moveNodesCube(flip: flip)
        self.stepsPrevious?.insert(flip, at: 0)
        //self.stepsPrevious?.append(flip)
    }
    
    // MARK: Шаг назад.
    private func stepPrevious() {
        if self.stepsPrevious == nil { return }
        if self.stepsPrevious!.isEmpty { return }
        guard let flip = self.stepsPrevious?.removeFirst() else { return }
        let reverse = flip.faceOpposite()!
        moveNodesCube(flip: reverse)
        self.stepsNext?.insert(flip, at: 0)
        //self.stepsNext?.append(flip)
    }
    
    // MARK: Возвращение в исходное состояние.
    private func resetCube() {
        self.scene?.rootNode.childNodes.forEach( { $0.removeFromParentNode() } )
        //addCube()
        viewDidLoad()
    }
    
    // MARK: Возвращает обратное значение вращения F -> F', U' -> U
//    private func reverseFlip(flip: String) -> String {
//        if flip.count == 2 {
//            if let first = flip.first {
//                return String(first)
//            }
//        }
//        return "\(flip)'"
//    }
    
    // MARK: Добавление куба на сцену.
    private func addCube() {
        for i in -1...1 {
            for j in -1...1 {
                for k in -1...1 {
                    let node = getBox(x: i * self.delta, y: j * self.delta, z: k * self.delta, len: self.delta)
                    self.scene?.rootNode.addChildNode(node)
                }
            }
        }
    }
    
    // MARK: Добавление куба на сцену по коорлинатам куба.
    private func addCubeFromCube() {
        for i in 0...2 {
            for j in 0...2 {
                for k in 0...2 {
                    let node = getBox(x: i * self.delta, y: j * self.delta, z: k * self.delta, len: self.delta)
                    node.name = "\(self.cube.numbers[i][j][k])"
                    self.scene?.rootNode.addChildNode(node)
                }
            }
        }
    }
    
    
    private func getBox(x: Int, y: Int, z: Int, len: Int) -> SCNNode {
            let box = SCNNode()
            let len = CGFloat(len)
        box.geometry = SCNBox(width: len, height: len, length: len, chamferRadius: 0.7)
            //box.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
            //box.position = SCNVector3Make(x, y, 0)
            //box.geometry!.firstMaterial!.diffuse.contents = NSString(stringLiteral: "Hello")
            //let im = NSImage(named: "\(number)")
        
        let colors = [NSColor.blue,     // front
                      NSColor.red,      // right
                      NSColor.green,    // back
                      NSColor.orange,   // left
                      NSColor.yellow,   // up
                      NSColor.white]    // down

            let sideMaterials = colors.map { color -> SCNMaterial in
                let material = SCNMaterial()
                material.diffuse.contents = color
                material.locksAmbientWithDiffuse = true
                return material
            }

            //materials = sideMaterials
            //let material = SCNMaterial()
        //material = sideMaterials
            //material.diffuse.contents = color
//            material.specular.contents = NSImage(named: "bubble")
//            //material.specular.contents = NSColor.white
//            material.shininess = 1 // блеск
        
        box.geometry?.materials = sideMaterials
            //box.geometry?.firstMaterial = material
            box.position = SCNVector3(x, y, z)
            return box
        }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        //guard let scene = self.scene else { return }
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        //flipCube(flips: ["L'", "L", "L"])
        //self.scene?.rootNode.replaceChildNode(temp!, with: self.central)
        //temp?.removeFromParentNode()
        //temp = nil
        
        //rotate(boxRed, around: SCNVector3(1, 0, 0), by: 40, duration: 4, completionBlock: nil)
        //boxRed.rotation = SCNVector4(0, 1, 0, 0.1)
//        boxRed.physicsBody = SCNPhysicsBody.dynamic()
//        scene.physicsWorld.gravity = SCNVector3(0, 0, 0)
//
//        boxRed.physicsBody?.applyTorque(SCNVector4(1, 1, 1, 2), asImpulse: true)
//
//        boxRed.runAction(SCNAction.wait(duration: 2), completionHandler: {
//            var axis = SCNVector3(1, 1, 1)
//            axis = scene.rootNode.convertPosition(axis, to: boxRed)
//            boxRed.physicsBody?.applyTorque(SCNVector4(x: axis.x, y: axis.y, z: axis.z, w: 2), asImpulse: true)
//        })
        
//        scene.rootNode.addChildNode(boxRed)
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}

func * (left: SCNMatrix4, right: SCNMatrix4) -> SCNMatrix4 {
    return SCNMatrix4Mult(left, right)
}

extension SCNVector3 {
    static func == (left: SCNVector3, right: SCNVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
}
