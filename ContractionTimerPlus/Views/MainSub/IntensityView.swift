//
//  PainItem.swift
//  ContactionTimer
//
//  Created by ismail örkler on 24.02.2025.
//

import SwiftUI

struct IntensityItem : View {
    
    private let wh : CGFloat = 10.0
    let intensity: Int
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4)
        {
            Circle().fill(intensity < 1 ? .d9 : .b1)
                .frame(width: wh, height: wh)
            
            Circle().fill(intensity < 2 ? .d9 : .b2)
                .frame(width: wh, height: wh)
            
            Circle().fill(intensity < 3 ? .d9 : .b3)
                .frame(width: wh, height: wh)
            
            Circle().fill(intensity < 4 ? .d9 : .b4)
                .frame(width: wh, height: wh)
            
            Circle().fill(intensity < 5 ? .d9 : .b5)
                .frame(width: wh, height: wh)
        }
        .padding(0)
    }
}


#Preview
{
    IntensityItem(intensity: 5)
}
   
