class WritingController: ObservableObject {
    @Published var drawing: PKDrawing?
    @Published var imgData: Data?

    init(drawing: PKDrawing? = nil, img: Data? = nil) {
        self.drawing = drawing
        self.imgData = img
    }
}
