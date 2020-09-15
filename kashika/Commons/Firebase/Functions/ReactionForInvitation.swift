//
//  ReactionForInvitation.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseFunctions

struct ReactionForInvitation: CallableFunctions {

    static let name = "reactionForInvitation"

    typealias Input = Request
    typealias Output = Response
}

extension ReactionForInvitation {
    enum ActionType: String, Codable {
        case deny, accept
    }

    struct Request: Encodable {
        let token: String
        let userId: String
        let friendId: String
        var linkedUserId: String? 
        let action: ActionType
    }

    struct Response: Decodable {
        let result: String
    }
}
