struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: -8) {
            LottieView(animation: .named("search-a.json"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .frame(width: 80, height: 80, alignment: .center)
                .rotationEffect(Angle(degrees: -90))
            
            Text("No results found")
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(.primary600)
                .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}