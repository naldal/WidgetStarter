//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by WM-ID002346 on 2022/11/14.
//  Copyright © 2022 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider { // 위젯을 랜더링 할 시기 컨트롤
  public typealias Entry = SimpleEntry
  
  func placeholder(in context: Context) -> Entry {
    Entry(date: Date(), configuration: ConfigurationIntent(), character: .panda)
  }
  
  // 위젯의 현재 상태를 나타내는 스냅샷 생성
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> ()) {
    let entry = Entry(date: Date(), configuration: configuration, character: .panda)
    completion(entry)
  }
  // 위젯에 대한 작업을 처리할 시간 배열
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [Entry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = Entry(date: entryDate, configuration: configuration, character: .panda)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let character: CharacterDetail
}

//struct PlaceholderView: View {
//  var body: some View {
//    AvatarView(.panda)
//      .isplacehole
//  }
//}

// 바탕화면에 보일 위젯 화면
struct EmojiRangerWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    AvatarView(entry.character)
      .redacted(reason: .placeholder)
  }
}

// 위젯 선택화면에서 보여질 화면설정
@main
struct EmojiRangerWidget: Widget {
  let kind: String = "EmojiRangerWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      EmojiRangerWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Emoji Ranger Detail")
    .description("Keep track fo your favorite emoji ranger")
    .supportedFamilies([.systemSmall])
  }
}

struct EmojiRangerWidget_Previews: PreviewProvider {
  static var previews: some View {
    AvatarView(.panda)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    
    
  }
}
