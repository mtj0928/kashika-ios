//
//  AddUserManuallyInteractorTest.swift
//  kashikaTests
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import XCTest
import Firebase
import Ballcap
import RxBlocking
@testable import kashika

class AddUserManuallyInteractorTest: XCTestCase {

    override func setUp() {
//        BallcapApp.configure(Firestore.firestore().document("test/1"))
    }

    override func tearDown() {
        do {
            try Auth.auth().signOut()
        } catch { }
    }

    func testCreatFriend() throws {
        let monitor = AddUserManuallyInteractor().addUser(name: "名前", icon: nil)
        let friend = try monitor.filter({ $0.value != nil }).toBlocking().first()?.value

        XCTAssertNotNil(friend as Any?)
        XCTAssertEqual(friend??.name, "名前")
    }
}
