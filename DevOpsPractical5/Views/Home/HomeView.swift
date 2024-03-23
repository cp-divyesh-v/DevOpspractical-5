//
//  HomeView.swift
//  DevOpsPractical5
//
//  Created by Divyesh Vekariya on 23/03/24.
//

import SwiftUI
import WebKit

struct HomeView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Count-down Timer").font(.title)
                
                HStack {
                    PlaceholderTextField("Hours", value: $viewModel.hours, formatter: NumberFormatter())
                    PlaceholderTextField("Minutes", value: $viewModel.minutes, formatter: NumberFormatter())
                    PlaceholderTextField("Seconds", value: $viewModel.seconds, formatter: NumberFormatter())
                }
                .padding()
                
                Text("Remaining Time: \(viewModel.timeStringFromTimeInterval(viewModel.remainingTime))")
                    .padding()
                Text("Elapsed Time: \(viewModel.timeStringFromTimeInterval(viewModel.elapsedTime))")
                
                Button(action: {
                    if viewModel.isTimerRunning {
                        viewModel.stopTimer()
                    } else {
                        viewModel.startTimer()
                    }
                }) {
                    Text(viewModel.isTimerRunning ? "Stop" : "Start")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .background(content: {
                    GifImage("rocket")
                })
                .padding()
                Button {
                    viewModel.resetTimer()
                } label: {
                    Text("reset")
                }
            }
            if viewModel.showGif {
                GifImage("rocket")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct PlaceholderTextField: View {
    let placeholder: String
    @Binding var value: Int
    var formatter: NumberFormatter

    init(_ placeholder: String, value: Binding<Int>, formatter: NumberFormatter) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
    }

    var body: some View {
        TextField(placeholder, text: Binding(
            get: { value == 0 ? "" : "\(value)" },
            set: {
                if let newValue = formatter.number(from: $0)?.intValue {
                    value = newValue
                }
            }
        ))
        .keyboardType(.numberPad)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}
