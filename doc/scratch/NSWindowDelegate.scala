class MyWindowDelegate extends NSObject {
    @message("(BOOL)window:(NSWindow *)sender shouldDragDocumentWithEvent:(NSEvent *)mouseEvent from:(NSPoint)startPoint withPasteboard:(NSPasteboard *)pasteboard")
    def windowShouldDragDocumentWithEventFromWithPasteboard(window: NSWindow, mouseEvent: NSEvent, startPoint: NSPoint, pasteboard: NSPasteboard): Boolean = {
        window!(`window->window, `shouldDragDocumentWithEvent->mouseEvent, `from->startPoint, `withPasteboard->pasteboard)
    }
}
