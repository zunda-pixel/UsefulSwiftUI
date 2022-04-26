import SwiftUI

struct ContentView: View {
  @State var renderingMode: BindSymbolRenderingMode = .palette

  @State var firstColor: Color = .red
  @State var secondColor: Color = .yellow
  @State var thirdColor: Color = .green
  @State var backgroundColor: Color = .purple
  @State var multiplyColor: Color = .white

  @State var variant:  SymbolVariants = .fill
  @State var size: Double = 100

  var body: some View {
    VStack {
      Image(systemName: "guitars")
        .symbolRenderingMode(renderingMode.bind)
        .symbolVariant(variant)
        .font(.system(size: size))
        .foregroundStyle(firstColor, secondColor, thirdColor)
        .background(backgroundColor)
        .colorMultiply(multiplyColor)
        .padding()
        .border(.blue, width: 10)

      ScrollView {
        Slider(value: $size, in: .init(uncheckedBounds: (0, 200))) {
          Text("Hello")
        }
        VStack {
          Picker("rendering mode", selection: $renderingMode) {
            ForEach(BindSymbolRenderingMode.allCases) { mode in
              Text(mode.rawValue)
                .tag(mode)
            }
          }
          .pickerStyle(.segmented)

          Picker("variant", selection: $variant) {
            ForEach(SymbolVariants.allCases) { variant in
              Text(variant.rawValue)
                .tag(variant)
            }
          }
          .pickerStyle(.segmented)

          ColorPicker("First Color", selection: $firstColor)
          ColorPicker("Second Color", selection: $secondColor)
          ColorPicker("Third Color", selection: $thirdColor)
          ColorPicker("Background Color", selection: $backgroundColor)
          ColorPicker("Multiply Color", selection: $multiplyColor)
        }
      }
    }
  }
}
