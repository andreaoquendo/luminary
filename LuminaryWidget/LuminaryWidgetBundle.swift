//
//  LuminaryWidgetBundle.swift
//  LuminaryWidget
//
//  Created by Andrea Oquendo on 29/09/23.
//

import WidgetKit
import SwiftUI

@main
struct LuminaryWidgetBundle: WidgetBundle {
    var body: some Widget {
        LuminaryWidget()
        LuminaryWidgetLiveActivity()
    }
}
