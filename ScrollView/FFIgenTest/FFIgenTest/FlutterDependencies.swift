//
//  FlutterDependencies.swift
//  FlutterScrollView
//
//  Created by 徐丽 on 2023/7/6.
//

import SwiftUI
import FlutterPluginRegistrant
import Flutter

// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
  let flutterEngine = FlutterEngine(name: "my flutter engine")
  init(){
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run()
    // Connects plugins with iOS platform code to this app.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
  }
}
