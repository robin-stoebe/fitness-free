//
//  StepsForWeek.swift
//  Personal Fitness Free
//
//  Created by Junior Paniagua on 7/17/23.
//

import SwiftUI
import HealthKit


struct StepsView: View {
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    
    init(){
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics(statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { ( statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int (count ?? 0), date: statistics.startDate)
            
            steps.append(step)
        }
    }
    
    var body: some View {

            
            List(steps, id: \.id){ step in
                
                VStack(alignment: .leading){
                        
                    Text("\(step.count)" + " steps")
                    Text(step.date, style: .date)
                        .opacity(0.5) // how faded the date is
                    
            }
            .navigationTitle("Just Walking")
        }
        .onAppear{
            if let healthStore = healthStore{
                healthStore.requestAuthorization{ success in
                    if success {
                        healthStore.calculateSteps{ statisticsCollection in
                            if let statisticsCollection = statisticsCollection{
                                //update the UI
                                updateUIFromStatistics(statisticsCollection: statisticsCollection)
                            }
                        }
                    }
                }
            }
        }
    }
}

