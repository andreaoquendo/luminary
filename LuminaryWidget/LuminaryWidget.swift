//
//  LuminaryWidget.swift
//  LuminaryWidget
//
//  Created by Andrea Oquendo on 29/09/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            
        let entry = SimpleEntry(date: currentDate, configuration: configuration)
        entries.append(entry)
        

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LuminaryWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text(QuotesHelper.getRandomQuote()?.quote ?? "Loading...")
                .multilineTextAlignment(.center)
                .font(.appBody)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(Color.primaryLuminary)
    }
    
}

struct LuminaryWidget: Widget {
    let kind: String = "LuminaryWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LuminaryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote of the Day")
        .description("See your Luminary quote of the day.")
        .contentMarginsDisabled()
    }
}

struct LuminaryWidget_Previews: PreviewProvider {
    static var previews: some View {
        LuminaryWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
