//
//  CurrentDayView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import SwiftUI

struct CurrentDayView: View {
    @EnvironmentObject var dayViewModel: DayViewModel
    @StateObject var storyViewModel = StoryViewModel()
    @State var story = ""
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    if let photos = dayViewModel.currentDay?.photos, !photos.isEmpty {
                        ForEach(dayViewModel.currentDay?.photos ?? [], id: \.id) { photo in
                            PhotoRowCell(photo: photo)
                        }
                        PhotosMapView(photos: photos)
                        Button("Generate a narrative"){
                            storyViewModel.generateStory(with: photos){ generatedStory in
                                story = generatedStory
                            }
                        }
                        .padding(10)
                        if (storyViewModel.story != ""){
                            Text(storyViewModel.story)
                                .padding(20)
                                .foregroundColor(.blue)
                            HStack{
                                Button{
                                    storyViewModel.clearStory()
                                } label : {
                                    Text("Reset Story")
                                }
                                Spacer()
                                Button{
                                    dayViewModel.addStoryToDay(story: story)
                                } label: {
                                    Text("Save Story")
                                }
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        }
                        
                        
                        
                    }
                    else{
                        Text("No photos available for today. Go ahead and add some!")
                           .foregroundColor(.secondary)
                           .padding(50)
                    }
                }
                
            }
            .navigationTitle("Today's Photos")

        }

    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}



#Preview {
    CurrentDayView()
        .environmentObject(DayViewModel())
}
