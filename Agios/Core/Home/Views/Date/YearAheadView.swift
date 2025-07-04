struct YearAheadView: View {
    @ObservedObject private var occasionViewModel: OccasionsViewModel
    
    init(occasionViewModel: OccasionsViewModel) {
        self.occasionViewModel = occasionViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(occasionViewModel.yearAheadFeasts) { item in
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                    occasionViewModel.copticDateTapped = false
                                }
                                HapticsManager.instance.impact(style: .light)
                                
                            }, label: {
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(item.feastName)
                                        .foregroundStyle(.primary1000)
                                    
                                    Text(item.dateString)
                                        .font(.callout)
                                        .foregroundStyle(.primary1000.opacity(0.7))
                                        .lineLimit(1)
                                    
                                }
                                .fontWeight(.medium)
                                .padding(.vertical, 9)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.primary100)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                            })
                            .buttonStyle(BouncyButton())
                        }
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .frame(height: 250, alignment: .top)
            .padding(.top, 8)
        }
    }
}

struct YearAheadFeast: Codable, Identifiable {
    let id: UUID
    let feastName: String
    let dateString: String

    init(feastName: String, dateString: String) {
        self.id = UUID()
        self.feastName = feastName
        self.dateString = dateString
    }

    enum CodingKeys: String, CodingKey {
        case feastName, dateString
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        feastName = try container.decode(String.self, forKey: .feastName)
        dateString = try container.decode(String.self, forKey: .dateString)
        id = UUID()
    }
    
    static let items: [YearAheadFeast] = [
        YearAheadFeast(feastName: "Jonah's Fast", dateString: "10-12 February 2025"),
        YearAheadFeast(feastName: "Start of Lent", dateString: "24 February 2025"),
        YearAheadFeast(feastName: "Holy Week", dateString: "14-19 April 2025"),
        YearAheadFeast(feastName: "Resurrection", dateString: "20 April 2025"),
        YearAheadFeast(feastName: "Ascension", dateString: "29 May 2025"),
        YearAheadFeast(feastName: "Pentecost", dateString: "8 June 2025"),
        YearAheadFeast(feastName: "Start of Apostles' Fast", dateString: "9 June 2025"),
        YearAheadFeast(feastName: "Coptic New Year (Feast of El Nayrouz)", dateString: "11 September 2025"),
        YearAheadFeast(feastName: "The Start of Kiahk", dateString: "10 December 2025")
    ]
}
