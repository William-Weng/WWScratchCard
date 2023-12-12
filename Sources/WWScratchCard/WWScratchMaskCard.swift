//
//  WWScratchMaskCard.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/12.
//

import UIKit

class WWScratchMaskCard: UIView {
    
    var strokeWidth: CGFloat = 10
    var strokeColor: UIColor = .black
    
    private var paths: [CGMutablePath] = []
    private var currentPath: CGMutablePath?
    
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
    
    /// 清除刮過的路徑
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
        currentPath = nil
        redraw()
    }
    
    /// [重畫 => drawRect(_:)](https://www.jianshu.com/p/774329cd4bc2)
    func redraw() { setNeedsDisplay() }
}
