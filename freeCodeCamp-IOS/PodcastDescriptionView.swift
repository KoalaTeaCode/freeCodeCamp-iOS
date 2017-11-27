//
//  PodcastDescriptionView.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/18/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import ActiveLabel
import KTResponsiveUI
import BonMot

class PodcastDescriptionView: UIView {
    
    private lazy var label: ActiveLabel = {
        return ActiveLabel(leftInset: 15, topInset: 15, width: 375 - 30, height: 600)
    }()
    
    private let bottomMarginForLabel = UIView.getValueScaledByScreenHeightFor(baseValue: 30)
    
    override func performLayout() {
        self.backgroundColor = Stylesheet.Colors.offWhite
        
        self.addSubview(label)
        self.height = label.height
        
        label.numberOfLines = 0
        label.enabledTypes = [.url]
        label.textColor = Stylesheet.Colors.offBlack
        label.handleURLTap { url in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                Tracker.logMovedToWebView(url: url.absoluteString)
            } else {
                UIApplication.shared.openURL(url)
                Tracker.logMovedToWebView(url: url.absoluteString)
            }
        }
    }
    
    func setupView(podcastModel: PodcastViewModel) {
        podcastModel.getHTMLDecodedAttributedString { (attributedString) in
            let text = attributedString!
            let style = StringStyle(
                .font(UIFont.systemFont(ofSize: 16))
            )
//            text.enumerateAttribute(NSAttributedStringKey.attachment, in: NSMakeRange(0, text.length), options: .init(rawValue: 0), using: { (value, range, stop) in
//                if let attachement = value as? NSTextAttachment {
//                    let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
//                    let screenSize: CGRect = UIScreen.main.bounds
//                    if image.size.width > screenSize.width {
//                        let newImage = image.resizeImage(scale: (screenSize.width)/image.size.width)
//                        let newAttribut = NSTextAttachment()
//                        newAttribut.image = newImage
//                        text.addAttribute(NSAttributedStringKey.attachment, value: newAttribut, range: range)
//                    }
//                }
//            })
            self.label.attributedText = text.styled(with: style)
            self.label.sizeToFit()
            self.height = self.label.height + self.bottomMarginForLabel
        }
    }
}

extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
