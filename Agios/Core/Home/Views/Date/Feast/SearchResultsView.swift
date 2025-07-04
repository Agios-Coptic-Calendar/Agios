struct SearchResultsView: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    let searchedDates: [String]
    @FocusState.Binding var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            if searchedDates.isEmpty {
                EmptySearchView()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(searchedDates, id: \.self) { date in
                            SearchResultRow(
                                date: date,
                                occasionViewModel: occasionViewModel,
                                onTap: {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                        occasionViewModel.copticDateTapped = false
                                        occasionViewModel.datePicker = occasionViewModel.date(from: date) ?? Date()
                                        isTextFieldFocused = false
                                    }
                                    HapticsManager.instance.impact(style: .light)
                                }
                            )
                        }
                    }
                    .foregroundStyle(.primary1000)
                    .padding(.vertical, 8)
                    .padding(.bottom, 30)
                    .padding(.top, 4)
                }
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom)
        ))
    }
}