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
    
    var stepsNext: [String]?
    var stepsPrevious: [String]?
    
    let duration: TimeInterval = 0.1
    
    var actions = [SCNAction]()
    
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
        case Key_R = 15         // Reset
    }
    
    enum Axis {
        case X
        case Y
        case Z
    }
    
    enum Turn {
        case clockwise
        case counterclockwise
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        self.scene = SCNScene(named: "art.scnassets/ship.scn")
        guard let scene = self.scene else { return }
        
        addEvents()
        //self.stepsNext = ["L", "U", "D", "F", "L", "U", "D", "F", "L", "U", "D", "F", "L", "U", "D", "F"]
        self.stepsNext = parserArraySteps(steps: [ "R2", "D'", "B'", "D", "F2", "R", "F2", "R2", "U", "L'", "F2", "U'", "B'", "L2", "R", "D", "B'", "R'", "B2", "L2", "F2", "L2", "R2", "U2", "D2"])
        print(stepsNext!.count)
        self.stepsPrevious = []
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
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
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
        
        addCube()
        
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
            flipLeft(turn: .clockwise)
        case Key.Key_S.rawValue:
            flipLeft(turn: .counterclockwise)
        case Key.Key_D.rawValue:
            flipUp(turn: .counterclockwise)
        case Key.Key_F.rawValue:
            flipUp(turn: .clockwise)
        case Key.Key_J.rawValue:
            flipDown(turn: .clockwise)
        case Key.Key_K.rawValue:
            flipDown(turn: .counterclockwise)
        case Key.Key_L.rawValue:
            flipRight(turn: .counterclockwise)
        case Key.Key_Semicolon.rawValue:
            flipRight(turn: .clockwise)
        case Key.Key_Z.rawValue:
            flipFront(turn: .counterclockwise)
        case Key.Key_X.rawValue:
            flipFront(turn: .clockwise)
        case Key.Key_C.rawValue:
            flipBack(turn: .clockwise)
        case Key.Key_V.rawValue:
            flipBack(turn: .counterclockwise)
        case Key.Key_Q.rawValue:
            stepNext()
        case Key.Key_W.rawValue:
            stepPrevious()
        case Key.Key_R.rawValue:
            resetCube()
        default:
            return false
        }
        return true
    }
    
    // MARK: Шаг вперед.
    private func stepNext() {
        if self.stepsNext == nil { return }
        if self.stepsNext!.isEmpty { return }
        guard let flip = self.stepsNext?.removeLast() else { return }
        while true {
            if flipCube(flip: flip) {
                break
            }
        }
        self.stepsPrevious?.append(flip)
    }
    
    // MARK: Шаг назад.
    private func stepPrevious() {
        if self.stepsPrevious == nil { return }
        if self.stepsPrevious!.isEmpty { return }
        guard let flip = self.stepsPrevious?.removeLast() else { return }
        let reverse = reverseFlip(flip: flip)
        while true {
            if flipCube(flip: reverse) {
                break
            }
        }
        self.stepsNext?.append(flip)
    }
    
    // MARK: Возвращение в исходное состояние.
    private func resetCube() {
        self.scene?.rootNode.childNodes.forEach( { $0.removeFromParentNode() } )
        //addCube()
        viewDidLoad()
    }
    
    // MARK: Возвращает обратное значение вращения F -> F', U' -> U
    private func reverseFlip(flip: String) -> String {
        if flip.count == 2 {
            if let first = flip.first {
                return String(first)
            }
        }
        return "\(flip)'"
    }
    
    // MARK: Вращение и движение кубиков.
    private func moveRotateNode(nodes: [SCNNode], axis: Axis, turn: Turn) -> Bool {
        if nodes.count != 9 { return false }
        if !checkLokationNodes(nodes: nodes) { return true }
        nodes.forEach( {
            animateRotateMoveNode(node: $0, axis: axis, turn: turn)
        } )
        self.flag = true
        return true
    }
   
    // MARK: Проверяет позицию всех кубиков. Они должны стоять в 4, -4, 0
    private func checkLokationNodes(nodes: [SCNNode]) -> Bool {
        for node in nodes {
            if !isCorrectСoordinates(coordinate: node.position.x){
                return false
            }
            if !isCorrectСoordinates(coordinate: node.position.y){
                return false
            }
            if !isCorrectСoordinates(coordinate: node.position.z){
                return false
            }
        }
        return true
    }
    
    // MARK: Проверяет координаты. Они должны бить 0, 4, -4
    private func isCorrectСoordinates(coordinate: CGFloat) -> Bool {
        switch coordinate {
        case 0:
            return true
        case 4:
            return true
        case -4:
            return true
        default:
            return false
        }
    }
    
    // MARK: Вращение левой грани L по или против часовой стрелке.
    private func flipLeft(turn: Turn) {
        while true {
            print("lsl")
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.x == -4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .X, turn: turn) { return }
        }
    }
    
    // MARK: Вращение верхней грани U по или против часовой стрелке.
    private func flipUp(turn: Turn) {
        while true {
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.y == 4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .Y, turn: turn) { return }
        }
    }
    
    // MARK: Вращение нижней грани D по или против часовой стрелке.
    private func flipDown(turn: Turn) {
        while true {
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.y == -4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .Y, turn: turn) { return }
        }
    }
    
    // MARK: Вращение правой грани R по или против часовой стрелке.
    private func flipRight(turn: Turn) {
        while true {
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.x == 4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .X, turn: turn) { return }
        }
    }
    
    // MARK: Вращение передней грани F по или против часовой стрелке.
    private func flipFront(turn: Turn) {
        while true {
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.z == 4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .Z, turn: turn) { return }
        }
    }
    
    // MARK: Вращение передней грани B по или против часовой стрелке.
    private func flipBack(turn: Turn) {
        while true {
            guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.z == -4 } ) else { return }
            if moveRotateNode(nodes: nodes, axis: .Z, turn: turn) { return }
        }
    }
    
    // MARK: Впредвижение ПО или ПРОТИВ часовой стредке, вокруг указанной оси.
    private func animateRotateMoveNode(node: SCNNode, axis: Axis, turn: Turn) {
        var position = node.position
        let chengeCoordinate: (inout CGFloat, inout CGFloat) -> ()
        let angle: CGFloat
        var positionAxis: SCNVector3
        if turn == .clockwise {
            angle = .pi / 2
            chengeCoordinate = chengeCoordinateClockwise
        } else {
            angle = -.pi / 2
            chengeCoordinate =  chengeCoordinateCounterclockwise
        }
        switch axis {
        case .X:
            positionAxis = SCNVector3(1, 0, 0)
            chengeCoordinate(&position.z, &position.y)
        case .Y:
            positionAxis = SCNVector3(0, 1, 0)
            chengeCoordinate(&position.x, &position.z)
        case .Z:
            positionAxis = SCNVector3(0, 0, 1)
            chengeCoordinate(&position.y, &position.x)
        }
        let move = SCNAction.move(to: position, duration: self.duration)
        move.timingMode = .easeInEaseOut
        let rotate = SCNAction.rotate(by: angle, around: positionAxis, duration: self.duration)
        rotate.timingMode = .easeInEaseOut
        let moveRotate = SCNAction.group([move, rotate])
        //node.runAction(move)
        node.runAction(moveRotate)
//        let action = SCNAction.customAction(duration: 0, action: { (nodeA, timer) in
//
//        })
//        actions.append(action)
    }
    
    // MARK: Высичляет новые коорлинаты для ячейки, при повороте ПО часовой стрелке.
    private func chengeCoordinateClockwise( left: inout CGFloat, right: inout CGFloat)  {
        if left + right == 0 {
            left = -left
        } else if abs(left + right) == 8 {
            right = -right
        } else if abs(left + right) == 4 {
            if left == 0 {
                (left, right) = (right, left)
            } else {
                (left, right) = (-right, -left)
            }
        }
    }
    
    // MARK: Высичляет новые коорлинаты для ячейки, при повороте ПРОТИВ часовой стрелки.
    private func chengeCoordinateCounterclockwise( left: inout CGFloat, right: inout CGFloat) {
        if left + right == 0 {
            right = -right
        } else if abs(left + right) == 8 {
            left = -left
        } else if abs(left + right) == 4 {
            if left == 0 {
                (left, right) = (-right, -left)
            } else {
                (left, right) = (right, left)
            }
        }
    }
    
    // MARK: Добавление куба на сцену.
    private func addCube() {
        let delta = 4
        for i in -1...1 {
            for j in -1...1 {
                for k in -1...1 {
                    let node = getBox(x: i * delta, y: j * delta, z: k * delta, len: delta)
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
                      NSColor.yellow,   // top
                      NSColor.white]    // bottom

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

    // MARK: Выполнение заданной последовательности вращений куба.
    func flipCube(flip: String) -> Bool {
        
        guard self.flag else { return  false }
        self.flag = false
        usleep(useconds_t(1000000 * self.duration + 50000))
//        sleep(1)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Put your code which should be executed with a delay here
//        }
        print(flip)
        switch flip {
        case "L":
            self.flipLeft(turn: .clockwise)
        case "L'":
            self.flipLeft(turn: .counterclockwise)
        case "U":
            self.flipUp(turn: .counterclockwise)
        case "U'":
            self.flipUp(turn: .clockwise)
        case "D":
            self.flipDown(turn: .clockwise)
        case "D'":
            self.flipDown(turn: .counterclockwise)
        case "R":
            self.flipRight(turn: .counterclockwise)
        case "R'":
            self.flipRight(turn: .clockwise)
        case "F":
            self.flipFront(turn: .counterclockwise)
        case "F'":
            self.flipFront(turn: .clockwise)
        case "B":
            self.flipBack(turn: .clockwise)
        case "B'":
            self.flipBack(turn: .counterclockwise)
        default:
            break
            //sleep(3)
        }
        return true
        /*
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
     }
         */
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
