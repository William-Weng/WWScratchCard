//
//  Extension.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit

// MARK: - CGSize (function)
extension CGSize {
    
    /// 計算像素個數
    /// - Returns: Int
    func _byteCount() -> Int {
        return Int(width) * Int(height)
    }
}

// MARK: - CGContext (static function)
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

// MARK: - UIImage (function)
extension UIImage {
    
    /// 計算圖片的像素個數
    /// - Returns: Int
    func _bitmapByteCount() -> Int {
        return size._byteCount()
    }
    
    /// 取得Context for CGBitmapInfo
    /// - Parameters:
    ///   - bitmapInfo: CGBitmapInfo
    ///   - colorSpace: CGColorSpace
    ///   - bitsPerComponent: Int
    /// - Returns: CGContext?
    func _bitmapContext(bitmapInfo: CGBitmapInfo, pixelData: inout UnsafeMutablePointer<UInt8>, colorSpace: CGColorSpace, bitsPerComponent: Int = 8) -> CGContext? {
        return CGContext._build(bitmapInfo: bitmapInfo, size: self.size, pixelData: pixelData, bitsPerComponent: bitsPerComponent, colorSpace: colorSpace)
    }
    
    /// [計算透明像素佔總像素的百分比](https://www.hangge.com/blog/cache/detail_1660.html)
    /// - Parameter alphaInfo: CGImageAlphaInfo
    /// - Returns: Float?
    func _alphaPixelPercent(_ alphaInfo: CGImageAlphaInfo = .alphaOnly, pixelData: inout UnsafeMutablePointer<UInt8>) -> Float? {
        
        guard let cgImage = self.cgImage,
              let context = self._bitmapContext(bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue), pixelData: &pixelData, colorSpace: CGColorSpaceCreateDeviceGray()),
              let bitmapByteCount = Optional.some(self._bitmapByteCount()),
              let size = Optional.some(self.size),
              let rect = Optional.some(CGRect(origin: .zero, size: size))
        else {
            return nil
        }
        
        var alphaPixelCount = 0
        
        context.clear(rect)
        context.draw(cgImage, in: rect)
        
        for x in 0...Int(size.width) {
            for y in 0...Int(size.height) {
                if pixelData[y * Int(size.width) + x] == 0 {
                    alphaPixelCount += 1
                }
            }
        }
        
        free(pixelData)
        return Float(alphaPixelCount) / Float(bitmapByteCount)
    }
}

// MARK: - UIImageView (function)
extension UIImageView {
    
    /// [刮刮樂效果](https://www.hangge.com/blog/cache/detail_1660.html)
    /// - Parameters:
    ///   - lineCap: 線條型式
    ///   - lineWidth: 線條寬度
    ///   - fromPoint: 線條起點
    ///   - toPoint: 線條終點
    /// - Returns: UIImage?
    func _eraseMaskImage(lineCap: CGLineCap = .round, lineWidth: CGFloat = 10.0, fromPoint: CGPoint, toPoint: CGPoint) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)

        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext(),
              let path = Optional.some(UIBezierPath()),
              let image = image
        else {
            return nil
        }
        
        image.draw(in: self.bounds)
        
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        context.setShouldAntialias(true)
        context.setLineCap(lineCap)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path.cgPath)
        context.strokePath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

