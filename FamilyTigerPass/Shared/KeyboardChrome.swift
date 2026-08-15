import SwiftUI
import UIKit

enum KeyboardChrome {
    static func dismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func toolWorkbench() -> some View {
        scrollDismissesKeyboard(.interactively)
            .kitchenChrome()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { KeyboardChrome.dismiss() }
                }
            }
    }
}
