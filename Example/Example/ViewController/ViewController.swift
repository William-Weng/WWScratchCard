//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/12/13.
//

import UIKit
import WWScratchCard

final class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scratchCard: WWScratchCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
}

// MARK: - WWScratchCardDelegate
extension ViewController: WWScratchCardDelegate {
    
    func scratchBegan(point: CGPoint) {}
    
    func scratchMoved(progress: Float) {
        scratchMovedAction(progress: progress, finishProgress: 0.7)
    }
    
    func scratchEnded(point: CGPoint) {}
}

// MARK: - 小工具
private extension ViewController {
    
    /// 測試
    func test() {
        
        guard let couponImage = UIImage(named: "Desktop.png"),
              let maskImage = UIImage(named: "Gray.png")
        else {
            return
        }
        
        scratchCard.setting(delegate: self, couponImage: couponImage, maskImage: maskImage, contentMode: .scaleToFill)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.scratchCard.restart(couponImage: couponImage, maskImage: maskImage, contentMode: .scaleToFill)
            self.label.text = "0.0 %"
        }
    }
    
    /// 刮刮樂的動作處理 (50%解鎖)
    /// - Parameters:
    ///   - progress: Float
    ///   - finishProgress: Float
    func scratchMovedAction(progress: Float, finishProgress: Float) {
        
        var percent = String(format: "%.1f", progress * 100)
        
        if (progress > 0.5) {
            percent = "100.0"
            scratchCard.finish()
        }
        
        label.text = "\(percent)%"
    }
}
