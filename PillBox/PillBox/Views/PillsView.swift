//
//  PillsView.swift
//  PillBox
//
//  Created by Максим Троицкий
//

import SwiftUI

struct PillsView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ZStack {
            VStack {
                HStack() {
                    Text("Список лекарств")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    addPillButton()
                }
                .padding()
                Spacer()
                
                MedicineListView()
            }
            .background(Color(red: 236/255, green: 240/255, blue: 255/255))
            
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
    
}

struct MedicineListView: View {
    @EnvironmentObject var dayPlanner: DayPlanner
    var body: some View {
        ScrollView {
            ForEach(dayPlanner.medicines, id:\.self) { medicine in
                if !medicine.isDeleted {
                    MedicineView(for: medicine)
                }
            }
        }
        
    }
}

struct addPillButton: View {
    @State private var isPresented = false
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(red: 177/255, green: 169/255, blue: 247/255))
        }
        .sheet(isPresented: $isPresented) {
            CreatePillView()
                .background(Color(red: 236/255, green: 240/255, blue: 255/255))
        }
        .background(Color(red: 236/255, green: 240/255, blue: 255/255))
    }
}

struct MedicineView: View {
    private var medicine: Medicine
    @EnvironmentObject var dayPlanner: DayPlanner
    @EnvironmentObject var vm: FileManagerViewModel
    @State private var typeList = ["табл.", "шт.", "мл.", "мг.", "гр.", "лож.", "ст. лож."]
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    init (for medicine: Medicine) {
        self.medicine = medicine
    }
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    dayPlanner.deleteMedicine(medicine: medicine)
                    vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == medicine.id})!])
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(maxWidth: 90, maxHeight: .infinity)
                })
            }
            .background(Color(red: 73/255, green: 169/255, blue: 166/255))
            .cornerRadius(25)
            .padding(.horizontal)
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image("\(medicine.medicineIcon)")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30)
                        Text("\(medicine.medicineName)")
                    }
                    Text("Годен до: \(medicine.expirationDate.monthYYYY())")
                        .font(.caption)
                }
                Spacer()
                Text("\(medicine.restOfMedicine) \(typeList[medicine.typeOfDosage])")
                    .foregroundColor(Float(medicine.restOfMedicine)! / Float(medicine.totalMedicine)! <= 0.2 ? .red : .black)
            }
            .padding()
            .background() {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .shadow(color: Color.black.opacity (0.08), radius: 5, x: 5, y: 5)
            }
            .padding(.horizontal)
            .offset(x: offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
        }
        
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                offset = value.translation.width - 90
            } else {
                offset = value.translation.width
            }
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    offset = -1000
                    dayPlanner.deleteMedicine(medicine: medicine)
                    vm.rewriteMedicine(medicine: dayPlanner.medicines[dayPlanner.medicines.firstIndex(where: {$0.id == medicine.id})!])
                } else if -offset > 50 {
                    isSwiped = true
                    offset = -90
                } else {
                    isSwiped = false
                    offset = 0
                }
            } else {
                isSwiped = false
                offset = 0
            }
        }
        
    }
}

struct PillsView_Previews: PreviewProvider {
    static var previews: some View {
        PillsView()
    }
}
