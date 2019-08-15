//
//  PhotoLibraryPickerOutput.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

class PhotoLibraryPickerOutput: NSObject, PhotoLibraryPickerOutputProtocol {
    var image: Observable<UIImage?> {
        return imageSubject
    }
    private let imageSubject = PublishSubject<UIImage?>()
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension PhotoLibraryPickerOutput: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageSubject.onNext(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
