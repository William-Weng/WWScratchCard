# WWScratchCard
[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWScratchCard) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

Imitation Scratch Card function.

仿刮刮樂功能。

![WWScratchCard](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWScratchCard.git", .upToNextMajor(from: "1.0.0"))
]
```

### Example
```swift
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
        let percent = String(format: "%.1f", progress * 100)
        label.text = "\(percent)%"
    }
    
    func scratchEnded(point: CGPoint) {}
}

// MARK: - 小工具
private extension ViewController {
    
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
}
```
