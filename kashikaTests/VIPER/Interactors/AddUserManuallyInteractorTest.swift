//
//  AddUserManuallyInteractorTest.swift
//  kashikaTests
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import XCTest
import Firebase
import RxBlocking
@testable import kashika

class AddUserManuallyInteractorTest: XCTestCase {

    override func tearDown() {
        do {
            try Auth.auth().signOut()
        } catch { }
    }

    func testCreatFriend() throws {
        let single = AddUserManuallyInteractor().addUser(name: "名前", icon: nil)
        let friend = try single.toBlocking().first()

        XCTAssertNotNil(friend as Any?)
        // swiftlint:disable force_unwrapping
        XCTAssertEqual(friend!!.name, "名前")
        // swiftlint:enable force_unwrapping
    }
}
