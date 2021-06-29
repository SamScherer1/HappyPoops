//
//  ContentSizedTableView.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 3/31/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation
import UIKit

class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
