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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demo(contentImagename: "Desktop", coverImagename: "Gray", resetTime: 5.0)
    }
}

private extension ViewController {
    
    func demo(contentImagename: String, coverImagename: String, resetTime: Double) {
        
        let contentView = UIImageView(image: UIImage(named: contentImagename))
        let coverView = UIImageView(image: UIImage(named: coverImagename))

        contentView.contentMode = .scaleAspectFill
        coverView.contentMode = .scaleAspectFill
        scratchCardView.setting(coverView: coverView, contentView: contentView, strokeWidth: 20.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + resetTime) {
            self.scratchCardView.clearCanvas()
        }
    }
}
