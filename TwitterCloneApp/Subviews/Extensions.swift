//
//  Extensions.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

//public class StartingButton: UIView {
//
//    public let button: UIButton
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

extension UIButton {
    convenience init(title: String,
                     tintColor: UIColor,
                     backgroundColor: UIColor) {
        self.init(type: .system)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.setTitle(title, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

extension UILabel {
    convenience init(title: String,
                     textAlignment: NSTextAlignment) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = textAlignment
        self.textColor = .white
        self.font = .systemFont(ofSize: 32, weight: .bold)
        self.text = title
    }
}

extension UILabel {
    convenience init(title: String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = .left
        self.textColor = .white
        self.font = .systemFont(ofSize: 16, weight: .regular)
        self.text = title
    }
}

extension UITextField {
    convenience init(title: String,
                     textContentType: UITextContentType,
                     returnKeyType: UIReturnKeyType) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.font = .systemFont(ofSize: 16, weight: .regular)
        self.textColor = .systemIndigo
        self.backgroundColor = .white
        self.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        self.returnKeyType = returnKeyType
        self.textContentType = textContentType
    }

    func setSecureTextEntry(_ isEnabled: Bool) {
        self.isSecureTextEntry = isEnabled
    }
}

extension UIImageView {
    convenience init(image: String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .secondaryLabel
        self.image = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))?.withRenderingMode(.alwaysTemplate)
    }
}

extension UILabel {
    convenience init(font: UIFont) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.textColor = .secondaryLabel
    }
}


