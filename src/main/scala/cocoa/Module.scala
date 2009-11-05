package cocoa

trait Module {
	private lazy val loaded = {
		Bridge.touch()
		load()
	}
	
	final def require = loaded
	
	/** can be override by subclasses to perform any initialization required */
	protected def load() {}
}