import sbt._
import Process._
import FileUtilities._

class CocoaScalaProject(info: ProjectInfo) extends DefaultProject(info) {
    val scalatest = "org.scala-tools.testing" % "scalatest" % "0.9.5"

    val frameworkPath = path("framework")
    val headersPath = frameworkPath / "jni-src"

	val targetPath = path("target")
    val targetFrameworkPath = targetPath / "CocoaScala.framework"
	val targetJNILibPath = targetPath / "libCocoaScala.jnilib"
    
    val nativeClasses = List(
        "cocoa.Bridge$",
        "cocoa.$ID",
		"cocoa.OCClass",
		"cocoa.Selector$",
		"cocoa.Method")
        
    override def cleanAction = super.cleanAction dependsOn cleanFramework
        
    lazy val javah = task {
        ("javah -classpath target/classes -d " + headersPath + " " + nativeClasses.mkString(" ")) ! log
        None
    } dependsOn(compile)
    
    lazy val framework = task {
        FileUtilities.clean(List(targetFrameworkPath), log)
        ("xcodebuild -target CocoaScala" cwd frameworkPath) ! log
        copyDirectory(frameworkPath / "build" / "Release" / "CocoaScala.framework", 
            targetFrameworkPath, 
            log)
        None
    } dependsOn(`package`)

    lazy val jnilib = task {
        FileUtilities.clean(List(targetJNILibPath), log)
        ("xcodebuild -target JNILib" cwd frameworkPath) ! log
        copyFile(frameworkPath / "build" / "Release" / "libCocoaScala.jniLib", 
            targetJNILibPath, 
            log)
        None
    }

    lazy val cleanFramework = task {
        ("xcodebuild clean" cwd frameworkPath) ! log
        None
    }

	lazy val testApp = task {
        "xcodebuild -target UnitTests".cwd(frameworkPath) ! log
		("open -W " + frameworkPath / "build" / "Release" / "UnitTests.app") ! log
		None
	} dependsOn(packageTest)
}
