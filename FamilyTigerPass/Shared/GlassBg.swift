import SwiftUI

struct GlassBg: View {
    var body: some View {
        ZStack {
            AppTheme.bgBase
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.55)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GlassBg()
}
