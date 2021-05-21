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
    
    var iter = 0
    
    let duration: TimeInterval = 0.5
    
    var actions = [SCNAction]()
    
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
        
        self.central = getBox(x: 0, y: 0, z: 0, len: 4, color: .red)
        //self.scene?.rootNode.addChildNode(self.central)
        //addUp()
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
    
    private func addEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
               return nil
            } else {
               return $0
            }
         }
    }
    
    private func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
           NSApplication.shared.keyWindow === locWindow else { return false }
        switch event.keyCode {
        case Key.Key_A.rawValue:
            flipLeft(turn: .clockwise)
            return true
        case Key.Key_S.rawValue:
            flipLeft(turn: .counterclockwise)
            return true
            /*
        case Key.Key_D.rawValue:
            flipUp(turn: .counterclockwise)
            return true
        case Key.Key_F.rawValue:
            flipUp(turn: .clockwise)
            return true
        case Key.Key_J.rawValue:
            flipDown(turn: .clockwise)
            return true
        case Key.Key_K.rawValue:
            flipDown(turn: .counterclockwise)
            return true
        case Key.Key_L.rawValue:
            flipRight(turn: .counterclockwise)
            return true
        case Key.Key_Semicolon.rawValue:
            flipRight(turn: .clockwise)
            return true
        case Key.Key_Z.rawValue:
            flipFront(turn: .counterclockwise)
            return true
        case Key.Key_X.rawValue:
            flipFront(turn: .clockwise)
            return true
        case Key.Key_C.rawValue:
            flipBack(turn: .clockwise)
            return true
        case Key.Key_V.rawValue:
            flipBack(turn: .counterclockwise)
            return true
 */
        default:
           break
        }
        return false
        
    }
    
    // MARK: Вращение левой грани L по или против часовой стрелке.
    private func flipLeft(turn: Turn) {
        guard let nodes = self.scene?.rootNode.childNodes.filter( {$0.position.x == -4 } ) else { return }
        moveRotateNode(nodes: nodes, axis: .X, turn: turn)
    }
    
    // MARK: Вращение и движение кубиков.
    private func moveRotateNode(nodes: [SCNNode], axis: Axis, turn: Turn) {
        if !checkLokationNodes(nodes: nodes) { return }
        nodes.forEach( {
            moveNode(node: $0, axis: axis, turn: turn, actions: &self.actions)
            rotateNode(node: $0, axis: axis, turn: turn)
        } )
        if let node = self.scene?.rootNode.childNodes.first {
            let sequence = SCNAction.sequence(actions)
            node.runAction(sequence)
        }
    }
    
    // MARK: Проверяет позицию всех кубиков.
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
    
    /*
    // MARK: Вращение верхней грани U по или против часовой стрелке.
    private func flipUp(turn: Turn) {
        guard let left = self.scene?.rootNode.childNodes.filter( {$0.position.y == 4 } ) else { return }
        left.forEach( {
            moveNode(node: $0, axis: .Y, turn: turn)
            rotateNode(node: $0, axis: .Y, turn: turn)
        } )
    }
    
    // MARK: Вращение нижней грани D по или против часовой стрелке.
    private func flipDown(turn: Turn) {
        guard let left = self.scene?.rootNode.childNodes.filter( {$0.position.y == -4 } ) else { return }
        left.forEach( {
            moveNode(node: $0, axis: .Y, turn: turn)
            rotateNode(node: $0, axis: .Y, turn: turn)
        } )
    }
    
    // MARK: Вращение правой грани R по или против часовой стрелке.
    private func flipRight(turn: Turn) {
        guard let left = self.scene?.rootNode.childNodes.filter( {$0.position.x == 4 } ) else { return }
        left.forEach( {
            moveNode(node: $0, axis: .X, turn: turn)
            rotateNode(node: $0, axis: .X, turn: turn)
        } )
    }
    
    // MARK: Вращение передней грани F по или против часовой стрелке.
    private func flipFront(turn: Turn) {
        guard let left = self.scene?.rootNode.childNodes.filter( {$0.position.z == 4 } ) else { return }
        left.forEach( {
            moveNode(node: $0, axis: .Z, turn: turn)
            rotateNode(node: $0, axis: .Z, turn: turn)
        } )
    }
    
    // MARK: Вращение передней грани B по или против часовой стрелке.
    private func flipBack(turn: Turn) {
        guard let left = self.scene?.rootNode.childNodes.filter( {$0.position.z == -4 } ) else { return }
        left.forEach( {
            moveNode(node: $0, axis: .Z, turn: turn)
            rotateNode(node: $0, axis: .Z, turn: turn)
        } )
    }
    */
    // MARK: Впредвижение ПО или ПРОТИВ часовой стредке, вокруг указанной оси.
    private func moveNode(node: SCNNode, axis: Axis, turn: Turn, actions: inout [SCNAction] ) {
        var position = node.position
        let chengeCoordinate: (inout CGFloat, inout CGFloat) -> ()
        if turn == .clockwise {
            chengeCoordinate = chengeCoordinateClockwise
        } else {
            chengeCoordinate =  chengeCoordinateCounterclockwise
        }
        switch axis {
        case .X:
            chengeCoordinate(&position.z, &position.y)
        case .Y:
            chengeCoordinate(&position.x, &position.z)
        case .Z:
            chengeCoordinate(&position.y, &position.x)
        }
        let action = SCNAction.customAction(duration: 0, action: { (nodeA, timer) in
            node.runAction(.move(to: position, duration: self.duration))
        })
        actions.append(action)
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
    
    // MARK: Вращение кубика по или против часовой стрелки.
    private func rotateNode(node: SCNNode, axis: Axis, turn: Turn) {
        let angle: CGFloat
        var position: SCNVector3
        if turn == .clockwise {
            angle = .pi / 2
        } else {
            angle = -.pi / 2
        }
        switch axis {
        case .X:
            position = SCNVector3(1, 0, 0)
        case .Y:
            position = SCNVector3(0, 1, 0)
        case .Z:
            position = SCNVector3(0, 0, 1)
        }
        node.runAction(.rotate(by: angle, around: position, duration: self.duration))
    }
    
    // MARK: Добавление куба на сцену.
    private func addCube() {
        let delta = 4
        for i in -1...1 {
            for j in -1...1 {
                for k in -1...1 {
                    let node = getBox(x: i * delta, y: j * delta, z: k * delta, len: delta, color: .yellow)
                    self.scene?.rootNode.addChildNode(node)
                }
            }
        }
        
    }
    
    private func getBox(x: Int, y: Int, z: Int, len: Int, color: NSColor) -> SCNNode {
            let box = SCNNode()
            let len = CGFloat(len)
        box.geometry = SCNBox(width: len, height: len, length: len, chamferRadius: 0.7)
            //box.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
            //box.position = SCNVector3Make(x, y, 0)
            //box.geometry!.firstMaterial!.diffuse.contents = NSString(stringLiteral: "Hello")
            //let im = NSImage(named: "\(number)")
        
        let colors = [NSColor.blue, // front
                      NSColor.red, // right
                      NSColor.green, // back
                      NSColor.orange, // left
                      NSColor.yellow, // top
                          NSColor.white] // bottom

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
        
        let temp : SCNNode? = getBox(x: 0, y: 0, z: 0, len: 4, color: .black)
        self.scene?.rootNode.addChildNode(temp!)
        if self.iter % 2 == 0 {
            guard let up = self.scene?.rootNode.childNodes.filter({$0.position.y == 4 && $0.position.x == 4}) else { return }
            print(up.count)
            up.forEach({ temp?.addChildNode($0) })
            temp?.runAction(.rotate(by: .pi / 2, around: SCNVector3(1, 0, 0), duration: 1))
            //up.forEach({ self.scene?.rootNode.addChildNode($0) })
        } else {
            guard let up = self.scene?.rootNode.childNodes.filter({$0.position.y == 4}) else { return }
            print(up.count)
            up.forEach({ temp?.addChildNode($0) })
            temp?.runAction(.rotate(by: .pi / 2, around: SCNVector3(0, 1, 0), duration: 1))
            //up.forEach({ self.scene?.rootNode.addChildNode($0) })
        }
        //self.scene?.rootNode.replaceChildNode(temp!, with: self.central)
        //temp?.removeFromParentNode()
        //temp = nil
        self.iter += 1
        
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
