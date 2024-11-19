//
//  UpcomingFeastView.swift
//  Agios
//
//  Created by Victor on 6/26/24.
//

import SwiftUI

struct UpcomingFeastView: View {
    @EnvironmentObject var vm: OccasionsViewModel
    let notable: Notable
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            VStack(spacing: 24) {
                VStack(alignment: .center, spacing: 24) {
                    HStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(notable.title)
                                .font(.title2)
                                .foregroundStyle(.gray900)
                                .fontWeight(.semibold)
                                .lineLimit(3)
                                .frame(alignment: .leading)
                                .frame(maxWidth: .infinity)
                            
                            Text("\(vm.datePicker.formatted(date: .abbreviated, time: .omitted))")
                                .fontWeight(.medium)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .background(.primary100)
                                .foregroundStyle(.primary1000)
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    }
                    ScrollView {
                        Text(notable.story)
                            .foregroundStyle(.gray700)
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                    .frame(maxHeight: 250)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
            .padding(.horizontal, 20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    vm.showUpcomingView = false
                    vm.selectedNotable = nil
                    HapticsManager.instance.impact(style: .soft)
                }
            } label: {
                NavigationButton(labelName: .close, backgroundColor: .white, foregroundColor: .gray900)
            }
            .buttonStyle(BouncyButton())
        }
        .kerning(-0.4)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    UpcomingFeastView(notable: Notable(copticDate: "",
                                       created: "",
                                       expand: Expand(copticDate: CopticDate(created: nil,
                                                                             day: "", id: "",
                                                                             month: "12",
                                                                             updated: "")),
                                       id: "123",
                                       story: "Story",
                                       title: "title",
                                       updated: "updated"))
        .environmentObject(OccasionsViewModel())
}
