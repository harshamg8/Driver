//
//  PieSliceModel.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public class PieSliceModel: CustomDebugStringConvertible {
    
    public let value: Double
    public let color: UIColor
    public let exactValue: Double
    public init(value: Double, exactVal: Double, color: UIColor) {
        self.value = value
        self.color = color
        self.exactValue = exactVal
    }
    
    public var debugDescription: String {
        return "{value: \(value)}"
    }
}
