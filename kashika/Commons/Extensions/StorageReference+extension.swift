//
//  StorageReference+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Firebase

extension StorageReference {

    static func create(with path: String, from storage: Firebase.Storage = Firebase.Storage.storage()) -> StorageReference {
        let refersnce = storage.reference(withPath: path)
        return refersnce
    }
}
