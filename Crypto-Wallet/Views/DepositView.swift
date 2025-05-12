import SwiftUI

struct DepositView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WalletViewModel
    @State private var depositAmount: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Deposit Funds")
                    .font(.largeTitle)

                TextField("Enter amount (AUD)", text: $depositAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if let amount = Double(depositAmount), amount > 0 {
                        viewModel.balance += amount
                        dismiss()
                    }
                }) {
                    Text("Confirm Deposit")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}
