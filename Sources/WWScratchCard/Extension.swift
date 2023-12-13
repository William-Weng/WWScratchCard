//
//  Extension.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit

extension CGSize {
    
    /// 計算像素個數
    /// - Returns: Int
    func _byteCount() -> Int {
        return Int(width) * Int(height)
    }
}

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
