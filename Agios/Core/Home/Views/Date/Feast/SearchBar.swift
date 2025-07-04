struct SearchBar: View {
    @Binding var searchText: String
    @FocusState.Binding var isTextFieldFocused: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.callout)
                .foregroundStyle(isTextFieldFocused ? .primary900 : .gray200)
            
            TextField("Search", text: $searchText)
                .foregroundStyle(.gray900)
                .frame(maxWidth: .infinity)
                .submitLabel(.search)
                .focused($isTextFieldFocused)
        }
        .fontWeight(.medium)
        .foregroundStyle(.gray300)
        .padding(.horizontal, 8)
        .padding(.vertical, 9)
        .background(.white)
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(isTextFieldFocused ? .primary900 : .gray200, lineWidth: 1)
        }
        .onTapGesture(perform: onTap)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}