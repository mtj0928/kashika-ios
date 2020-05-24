//
//  RootInteractorTest.swift
//  kashikaTests
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import XCTest
import Firebase
import Ballcap
import RxBlocking
@testable import kashika

class RootInteractorTest: XCTestCase {

    override func setUp() {
//        BallcapApp.configure(Firestore.firestore().document("test/1"))
    }

    override func tearDown() {
        do {
            try Auth.auth().signOut()
        } catch { }
    }

    func testCreateUser() throws {
        let single = RootInteractor().fetchOrCreateCurrentUser()
        let user = try single.toBlocking().first()
        XCTAssertNotNil(user as Any?)
    }

    func testFetchUser() throws {
        let single1 = RootInteractor().fetchOrCreateCurrentUser()
        let user1 = try single1.toBlocking().first()

        let single2 = RootInteractor().fetchOrCreateCurrentUser()
        let user2 = try single2.toBlocking().first()
        XCTAssertEqual(user1??.name, user2??.name)
    }
}
