//
//  WWScratchMaskCard.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/12.
//

import UIKit
import WWPrint

protocol ScratchMaskCardDelegate: NSObject {
    
    /// 取得刮的百分比數值
    /// - Parameters:
    ///   - maskCard: WWScratchMaskCard
    ///   - percent: 百分比
    func maskPercent(_ maskCard: WWScratchMaskCard, percent: Float?)
}

// MARK: - 刮刮樂的主功能
class WWScratchMaskCard: UIView {
        
    private var paths: [CGMutablePath] = []
    private var currentPath: CGMutablePath?
    
    var strokeWidth: CGFloat = 10
    var strokeColor: UIColor = .black
    
    weak var maskCardDelegate: ScratchMaskCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawing(with: rect)
    }
    
    @objc func panGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        panGestureRecognizerAction(with: recognizer)
    }
}

/// MARK: - 公開工具
extension WWScratchMaskCard {
    
    /// [清除刮過的路徑](https://www.hangge.com/blog/cache/detail_1660.html)
    func clearCanvas() {
        paths.removeAll()
        redraw()
    }
}

/// MARK: - 小工具
private extension WWScratchMaskCard {
    
    /// 畫線功能
    /// - Parameter recognizer: UIPanGestureRecognizer
    func panGestureRecognizerAction(with recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began: beginPath(at: location)
        case .changed: addLine(to: location)
        default: closePath()
        }
    }
    
    /// 畫線
    /// - Parameter rect: CGRect
    func drawing(with rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(strokeWidth)
        context.setLineCap(.round)
        
        for path in paths + [currentPath].compactMap({$0}) {
            context.addPath(path)
            context.strokePath()
        }
    }
    
    /// 開始畫線
    func beginPath(at point: CGPoint) {
        currentPath = CGMutablePath()
        currentPath?.move(to: point)
        redraw()
    }
    
    /// 加上畫線路徑
    func addLine(to point: CGPoint) {
        currentPath?.addLine(to: point)
        redraw()
    }
    
    /// 關閉畫線路徑
    func closePath() {
        
        if let currentPath = currentPath { paths.append(currentPath) }
        
        let screenshot = self._screenshot()
        var pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: screenshot._bitmapByteCount())
        let percent = screenshot._alphaPixelPercent(pixelData: &pixelData) ?? 1.0
        
        currentPath = nil
        redraw()
        maskCardDelegate?.maskPercent(self, percent: percent)
    }
    
    /// [重畫 => drawRect(_:)](https://www.jianshu.com/p/774329cd4bc2)
    func redraw() { setNeedsDisplay() }
}

extension CGContext {
    
    /// 建立Context for CGBitmapInfo
    /// - Parameters:
    ///   - bitmapInfo: CGBitmapInfo
    ///   - size: CGSize
    ///   - pixelData: UnsafeMutableRawPointer?
    ///   - bitsPerComponent: Int
    ///   - colorSpace: CGColorSpace
    /// - Returns: CGContext?
    static func _build(bitmapInfo: CGBitmapInfo, size: CGSize, pixelData: UnsafeMutableRawPointer?, bitsPerComponent: Int, colorSpace: CGColorSpace) -> CGContext? {
        
        let context = CGContext(data: pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: Int(size.width), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context
    }
}
