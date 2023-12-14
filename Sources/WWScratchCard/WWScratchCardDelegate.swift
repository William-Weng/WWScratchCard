//
//  WWScratchCardDelegate.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit

// MARK: - 刮刮樂Delegate
@objc public protocol WWScratchCardDelegate {
    
    /// 開始刮
    /// - Parameter point: CGPoint
    func scratchBegan(point: CGPoint)
    
    /// 正在刮
    /// - Parameter progress: 百分比
    func scratchMoved(progress: Float)
    
    /// 停止刮
    /// - Parameter point: CGPoint
    func scratchEnded(point: CGPoint)
}
