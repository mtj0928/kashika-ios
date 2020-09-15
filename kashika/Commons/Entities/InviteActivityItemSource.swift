//
//  InviteActivityItemSource.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/19.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit
import LinkPresentation
import SDWebImage

class InviteActivityItemSource: NSObject, UIActivityItemSource {

    private let linkMetadata: LPLinkMetadata
    private let url: URL
    private let friend: Friend

    init(_ friend: Friend, _ url: URL) {
        self.url = url
        self.friend = friend
        self.linkMetadata = LPLinkMetadata()
        super.init()

        linkMetadata.title = "\(friend.name)さんと紐付ける友達に送信してください"
        linkMetadata.url = url
        SDWebImageDownloader.shared.downloadImage(with: friend.iconFile?.url) { [weak self] (image, _, _, _) in
            guard let image = image else {
                return
            }
            self?.linkMetadata.imageProvider = NSItemProvider(object: image)
        }
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        linkMetadata
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        self.url
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        url
    }
}
