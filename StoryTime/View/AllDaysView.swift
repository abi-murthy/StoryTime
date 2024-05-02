//
//  AllDaysView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/30/24.
//

import Foundation
import SwiftUI

struct AllDaysView : View{
    
    @EnvironmentObject var dayViewModel: DayViewModel
    
    var body: some View {
        VStack{
            Text("All days")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            List{
                if !dayViewModel.days.isEmpty{
                    ForEach(dayViewModel.days, id: \.id) { day in
                        DayRowCell(day: day)
                    }
                }
                else {
                    Text("Add your first photo to make your first day!")
                }
                
                
            }
            
        }
        
    }
}


struct DayRowCell : View {
    let day: Day
    @State var isExpanded = false
    var body: some View{
        VStack{
          
            VStack(alignment: .leading){
                if let date = day.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .animation(nil, value: isExpanded)
                }
                
                Text(day.story)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(isExpanded ? nil : 3) // Expandable line limit
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
                    .padding(.bottom, day.photos.isEmpty ? 0 : 5)
            }
            .padding()
            VStack{
                if day.photos.count > 0{
                    PhotosMapView(photos: day.photos)
                        .frame(height: 300)
                        .padding(.bottom, 5)
                }
                else {
                    Text("No photos found for this day")
                }
            }
            
        }
    }
}


#Preview {
    AllDaysView()
        .environmentObject(DayViewModel())
}
