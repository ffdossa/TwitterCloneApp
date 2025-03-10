//
//  Extensions.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

extension UIView {
//    var width: CGFloat {
//        return frame.size.width
//    }
//
//    var height: CGFloat {
//        return frame.size.height
//    }
//
//    var left: CGFloat {
//        return frame.origin.x
//    }
//
//    var right: CGFloat {
//        return left + width
//    }
//
//    var top: CGFloat {
//        return frame.origin.y
//    }
//
//    var bottom: CGFloat {
//        return top + height
//    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}



//extension UILabel {
//    static func subLabel() -> UILabel  {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .secondaryLabel
//        label.font = .systemFont(ofSize: 15, weight: .regular)
//        return label
//    }()
//}
