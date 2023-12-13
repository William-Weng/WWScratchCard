//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/12/12.
//  ~/Library/Caches/org.swift.swiftpm/

import UIKit
import WWScratchCard

final class ViewController: UIViewController {
    
    @IBOutlet weak var scratchCardView: WWScratchCard!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demo(contentImagename: "Desktop", coverImagename: "Gray", resetTime: 5.0)
    }
}

// MARK: - ScratchCardDelegate
extension ViewController: ScratchCardDelegate {
    
    func maskPercent(_ maskCard: WWScratchCard, percent: Float?) {
        guard let percent = percent else { return }
        percentLabel.text = "\((1.0 - percent) * 100) %"
    }
}

// MARK: - 小工具
private extension ViewController {
    
    func demo(contentImagename: String, coverImagename: String, resetTime: Double) {
        
        let contentView = UIImageView(image: UIImage(named: contentImagename))
        let coverView = UIImageView(image: UIImage(named: coverImagename))

        contentView.contentMode = .scaleAspectFill
        coverView.contentMode = .scaleAspectFill
        scratchCardView.setting(maskCardDelegate: self, coverView: coverView, contentView: contentView, strokeWidth: 20.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + resetTime) {
            self.scratchCardView.clearCanvas()
        }
    }
}
