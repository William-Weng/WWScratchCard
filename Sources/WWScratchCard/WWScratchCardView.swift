//
//  WWScratchCardView.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit

// MARK: - 刮刮樂
open class WWScratchCardView: UIView {

    var scratchMask: WWScratchMaskView!
    var couponImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
}

// MARK: - 公開函式
public extension WWScratchCardView {
    
    /// [設定圖片相關設定](https://www.hangge.com/blog/cache/detail_1660.html)
    /// - Parameters:
    ///   - delegate: WWScratchCardDelegate?
    ///   - couponImage: 優惠卷圖片
    ///   - maskImage: 塗層圖片
    ///   - scratchWidth: 線條粗細
    ///   - scratchType: 線條樣式
    ///   - contentMode: UIView.ContentMode
    func setting(delegate: WWScratchCardDelegate? = nil, couponImage: UIImage, maskImage: UIImage, scratchWidth: CGFloat = 15, scratchType: CGLineCap = .square, contentMode: UIView.ContentMode = .scaleAspectFill) {
        
        restart(couponImage: couponImage, maskImage: maskImage, contentMode: contentMode)
        
        scratchMask.lineWidth = scratchWidth
        scratchMask.lineType = scratchType
        scratchMask.delegate = delegate
        
        setNeedsDisplay()
    }
    
    /// 重新開始
    /// - Parameters:
    ///   - couponImage: 優惠卷圖片
    ///   - maskImage: 塗層圖片
    func restart(couponImage: UIImage, maskImage: UIImage, contentMode: UIView.ContentMode = .scaleAspectFill) {
        couponImageView.contentMode = contentMode
        couponImageView.image = couponImage
        scratchMask.image = maskImage
    }
    
    /// 全部完成 (100%)
    func finish() {
        scratchMask.image = nil
    }
}

// MARK: - 小工具
private extension WWScratchCardView {
    
    /// 初始化設定
    func initSetting() {
        
        let maskFrame = CGRect(origin: .zero, size: self.frame.size)
        
        couponImageView = UIImageView(frame: maskFrame)
        scratchMask = WWScratchMaskView(frame: maskFrame)
        
        self.addSubview(couponImageView)
        self.addSubview(scratchMask)
    }
}
