//
//  UITableView+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Rswift

extension UITableView {

    func dequeueReusableCellAndWrap<Identifier: ReuseIdentifierType>(withReuseIdentifier identifier: Identifier, for indexPath: IndexPath) -> Identifier.ReusableType {
        guard let cell = dequeueReusableCell(withIdentifier: identifier.identifier, for: indexPath) as? Identifier.ReusableType else {
            assert(false, "Identifier, " + identifier.identifier + " is not registerd.")
        }
        return cell
    }
}
