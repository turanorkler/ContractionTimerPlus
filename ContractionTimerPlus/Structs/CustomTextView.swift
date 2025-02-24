//
//  CustomTextView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 19.02.2025.
//

import SwiftUI

struct CustomTextView: View {
  var text: String
  var lineSpacing: CGFloat

  var body: some View {
    VStack(alignment: .leading, spacing: lineSpacing) {
      ForEach(text.components(separatedBy: "\n"), id: \.self) { line in
        Text(line)
      }
    }
  }
}
