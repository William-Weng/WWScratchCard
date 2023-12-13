//
//  WWScratchCard.swift
//  WWScratchCard
//
//  Created by William.Weng on 2023/12/12.
//

import UIKit

public protocol ScratchCardDelegate: NSObject {
    
    /// 取得刮的百分比數值
    /// - Parameters:
    ///   - maskCard: WWScratchCard
    ///   - percent: 百分比
    func maskPercent(_ maskCard: WWScratchCard, percent: Float?)
}

// MARK: - 刮刮樂
open class WWScratchCard: UIView {
    
    private var coverView = UIView()
    private var contentView = UIView()
    private var contentMaskView = WWScratchMaskCard()
    private var panGesture = UIPanGestureRecognizer()
    
    var strokeWidth: CGFloat = 0 {
        didSet { contentMaskView.strokeWidth = strokeWidth }
    }
    
    weak var maskCardDelegate: ScratchCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - ScratchMaskCardDelegate
extension WWScratchCard: ScratchMaskCardDelegate {
    
    func maskPercent(_ maskCard: WWScratchMaskCard, percent: Float?) {
        maskCardDelegate?.maskPercent(self, percent: percent)
    }
}

// MARK: - 公開函數
public extension WWScratchCard {
    
    /// [設定相關參數](https://github.com/slamdon/Swift-Layout-Animation-Transition-30days/)
    /// - Parameters:
    ///   - coverView: 底圖
    ///   - contentView: 外層
    ///   - strokeWidth: 線寬
    func setting(maskCardDelegate: ScratchCardDelegate?, coverView: UIView, contentView: UIView, strokeWidth: CGFloat = 20.0) {
        viewSettings(coverView: coverView, contentView: contentView, strokeWidth: strokeWidth)
        self.maskCardDelegate = maskCardDelegate
    }
    
    /// 回復成未刮的狀態
    func clearCanvas() {
        contentMaskView.clearCanvas()
    }
}

// MARK: - 小工具
private extension WWScratchCard {
    
    /// 畫面設定
    /// - Parameters:
    ///   - coverView: 底圖
    ///   - contentView: 外層
    ///   - strokeWidth: 線寬
    func viewSettings(coverView: UIView, contentView: UIView, strokeWidth: CGFloat) {
        
        self.coverView = coverView
        self.contentView = contentView
        self.strokeWidth = strokeWidth
        
        contentMaskView.maskCardDelegate = self
        contentMaskView.frame = self.bounds
        contentMaskView.backgroundColor = .clear
        
        subViewConstraintSetting(coverView)
        subViewConstraintSetting(contentView)
        subViewConstraintSetting(contentMaskView)
        
        contentView.mask = contentMaskView
        panGestureSetting()
    }
    
    /// [設定刮刮樂View的大小 - VFL](https://www.appcoda.com.tw/auto-layout-programmatically/)
    /// - Parameter subview: [UIView](https://denkeni.medium.com/心得-純程式碼-auto-layout-vfl-c4a1fe57db98)
    func subViewConstraintSetting(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(0)-[subview]-(0)-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["subview": subview])
        )
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(0)-[subview]-(0)-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["subview": subview])
        )
    }
    
    /// 刮刮樂動作設定
    func panGestureSetting() {
        panGesture = UIPanGestureRecognizer(target: contentMaskView, action: #selector(contentMaskView.panGestureRecognizer))
        self.removeGestureRecognizer(panGesture)
        self.addGestureRecognizer(panGesture)
    }
}

extension UIView {
    
    /// [擷取UIView的畫面](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-uigraphicsimagerenderer-將-view-變成圖片-41d00c568903)
    /// - Parameter afterScreenUpdates: 更新後才擷取嗎？
    /// - Returns: UIImage
    func _screenshot(_ afterScreenUpdates: Bool = true) -> UIImage {
        
        let render = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = render.image { (_) in drawHierarchy(in: self.bounds, afterScreenUpdates: true) }
        
        return image
    }
}
