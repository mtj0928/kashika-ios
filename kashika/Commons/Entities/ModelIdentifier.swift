//
//  ModelIdentifier.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/10.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import RxSwift

protocol ModelIdentifier {
    var id: String { get }
}

extension ModelIdentifier where Self == User {

    func document() -> Single<Document<Self>> {
        return Document<Self>(id: id, from: self).ex.get()
    }
}

protocol UserObject: ModelIdentifier {
    static var collectionName: String { get }
    var userId: String { get }
}

extension ModelIdentifier where Self: Modelable & Codable & UserObject {

    func document() -> Single<Document<Self>> {
        let userDocument = Document<User>(id: userId)
        let collectionReference = userDocument.documentReference.collection(Self.collectionName)
        return Document<Self>(id: id, collectionReference: collectionReference).ex.get()
    }
}
