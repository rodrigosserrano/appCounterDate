//
//  ContentView.swift
//  AppCounter
//
//  Created by Rodrigo Serrano on 06/11/22.
//

import SwiftUI

class Counter: ObservableObject {
     
    @Published var days     = 0
    @Published var month    = 0
    @Published var hours    = 0
    @Published var minutes  = 0
    @Published var seconds  = 0
    
    var selectedDate = Date()
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let calendar = Calendar.current
            
            let components = calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: Date())
            
            let currentDate = calendar.date(from: components)
        
            let selectedComponents = calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: self.selectedDate)
            
            var eventDateComponets = DateComponents()
            eventDateComponets.year = selectedComponents.year
            eventDateComponets.month = selectedComponents.month
            eventDateComponets.day = selectedComponents.day
            eventDateComponets.hour = selectedComponents.hour
            eventDateComponets.minute = selectedComponents.minute
            eventDateComponets.second = selectedComponents.second
            
            let eventDate = calendar.date(from: eventDateComponets)
            
            let timeLeft = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: eventDate!)
            
            if (timeLeft.second!  >= 0) {
                self.days = timeLeft.day ?? 0
                self.hours = timeLeft.hour ?? 0
                self.minutes = timeLeft.minute ?? 0
                self.seconds = timeLeft.second ?? 0
            }
        }
    }
}

struct ContentView: View {
    @StateObject var counter = Counter()
    var body: some View {
        VStack {
            Text("Selecione a data do evento para saber quanto tempo falta")
                .bold()
                .frame(
                   maxWidth: 400,
                   maxHeight: 80,
                   alignment: .center)
                .multilineTextAlignment(.center)
            
            DatePicker(selection: $counter.selectedDate , in: Date()..., displayedComponents: [.hourAndMinute, .date]){}
            .padding()
            .datePickerStyle(.wheel)
            .background(Color.gray.opacity(0.16), in: RoundedRectangle(cornerRadius: 20))
            .padding()
            if (counter.seconds > 0) {
                HStack {
                    Text("\(counter.days) dias")
                    Text("\(counter.hours) horas")
                    Text("\(counter.minutes) min")
                    Text("\(counter.seconds) seg")
                }
                .frame(width: 335)
                .padding()
                .background(Color.gray.opacity(0.16), in: RoundedRectangle(cornerRadius: 20))
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
