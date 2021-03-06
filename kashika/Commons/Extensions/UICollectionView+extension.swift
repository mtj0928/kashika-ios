//
//  UICollectionView+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/06.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Rswift

extension UICollectionView {

    func dequeueReusableCellAndWrap<Identifier: ReuseIdentifierType>(withReuseIdentifier identifier: Identifier, for indexPath: IndexPath) -> Identifier.ReusableType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier.identifier, for: indexPath) as? Identifier.ReusableType else {
            fatalError("Identifier, " + identifier.identifier + " is not registerd.")
        }
        return cell
    }
}
