//
//  WWScratchMaskView.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit

// MARK: - 刮刮樂塗層
class WWScratchMaskView: UIImageView {
    
    var lineType: CGLineCap = .round
    var lineWidth: CGFloat = 10.0
    var lastPoint: CGPoint?
    
    weak var delegate: WWScratchCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scratchBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        scratchMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        scratchEnded(touches, with: event)
    }
}

// MARK: - 小工具
private extension WWScratchMaskView {
    
    /// 開始刮的處理 (記錄開始的點)
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func scratchBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let delegate = delegate,
              let touch = touches.first
        else {
            return
        }
        
        let lastPoint = touch.location(in: self)
        self.lastPoint = lastPoint
        
        delegate.scratchBegan(point: lastPoint)
    }
    
    /// 正在刮的處理 (開始畫線 => 合併圖層)
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func scratchMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let delegate = delegate,
              let touch = touches.first,
              let newPoint = Optional.some(touch.location(in: self)),
              let point = lastPoint,
              let eraseMaskImage = self._eraseMaskImage(fromPoint: point, toPoint: newPoint)
        else {
            return
        }
        
        var pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: eraseMaskImage._bitmapByteCount())
        let progress = eraseMaskImage._alphaPixelPercent(pixelData: &pixelData) ?? 1.0
        
        lastPoint = newPoint
        self.image = eraseMaskImage
        
        delegate.scratchMoved(progress: progress)
    }
    
    /// 刮完的處理 (手離開畫面)
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func scratchEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let delegate = delegate,
              !touches.isEmpty,
              let lastPoint = lastPoint
        else {
            return
        }
        
        delegate.scratchEnded(point: lastPoint)
    }
}
