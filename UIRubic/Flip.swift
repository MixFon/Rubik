//
//  Flip.swift
//  UIRubic
//
//  Created by Михаил Фокин on 27.05.2021.
//

import Foundation

enum Flip: String {
    case L = "L"
    case _L = "L'"
    case F = "F"
    case _F = "F'"
    case R = "R"
    case _R = "R'"
    case B = "B"
    case _B = "B'"
    case U = "U"
    case _U = "U'"
    case D = "D"
    case _D = "D'"
    
    static var flipClockwise: [Flip] { return [.L, .F, .R, .B, .U, .D] }
    static var flipCounterclockwise: [Flip] { return [._L, ._F, ._R, ._B, ._U, ._D] }
    static var allFlips: [Flip] { return flipClockwise + flipCounterclockwise }
    static var allFlipsOpposite: [Flip] { return flipCounterclockwise + flipClockwise }
    
    // Возсращает грань слева
    func faceLeft() -> Flip? {
        switch self {
        case .L:
            return .B
        case .F:
            return .L
        case .R:
            return .F
        case .B:
            return .R
        case .U:
            return .L
        case .D:
            return .L
        default:
            return nil
        }
    }
    
    // Возсращает грань справа
    func faceRight() -> Flip? {
        switch self {
        case .L:
            return .F
        case .F:
            return .R
        case .R:
            return .B
        case .B:
            return .L
        case .U:
            return .R
        case .D:
            return .R
        default:
            return nil
        }
    }
    
    // Возаращет поворот в противоположную сторону.
    func faceOpposite() -> Flip? {
        guard let index = Flip.allFlips.firstIndex(of: self) else { return nil }
        return Flip.allFlipsOpposite[index]
    }
}
