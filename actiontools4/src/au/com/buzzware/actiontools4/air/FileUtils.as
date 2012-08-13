package au.com.buzzware.actiontools4.air {

	import au.com.buzzware.actiontools4.code.StringUtils;
	
	import flash.filesystem.*;

public class FileUtils {

		public static function toFile(aFileOrName: Object): File {
			if (!aFileOrName)
				return null
			if (aFileOrName is File) {
				return aFileOrName as File
			} else {
				return fileFromFancyPath(aFileOrName as String)
			}
		}

		public static function toApplicationFile(aFileOrName: Object): File {
			if (!aFileOrName)
				return null
			if (aFileOrName is File) {
				return File(aFileOrName)
			} else {
				return File.applicationDirectory.resolvePath(String(aFileOrName))
			}
		}

		public static function fileToString(aFileOrName: Object): String {
			var file:File = mustExist(toFile(aFileOrName))
			if (!file)
				return null;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readMultiByte(file.size, File.systemCharset);
			fileStream.close();			
			return str;			
		}
		
		public static function stringToFile(aString: String,aFileOrName: Object): void {
			var file:File = toFile(aFileOrName)
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			//fileStream.writeString(aString);
			fileStream.writeMultiByte(aString, File.systemCharset);
			fileStream.close();			
		}
		
		public static function mustExist(aFile: File): File {
			if (!aFile)
				return null
			return (aFile.exists ? aFile : null)
		}
		
		public static function fileMustExist(aFile: File): File {
			if (!aFile)
				return null
			return ((aFile.exists && !aFile.isDirectory) ? aFile : null)
		}
		
		public static function dirMustExist(aFile: File): File {
			if (!aFile)
				return null
			return ((aFile.exists && aFile.isDirectory) ? aFile : null)
		}
		
		public static function filenameExists(aFilename: String): Boolean {
			var f: File = toApplicationFile(aFilename)
			if (!f)
				return false;
			return fileMustExist(f) ? true : false;
		}
		
		public static function isWindowsPath(aPath: String): Boolean {
			if (!aPath)
				return false;
			var fwd: int;
			var back: int;
			for (var i:int = 0;i<aPath.length;i++) {
				if (aPath.charAt(i)=='/')
					fwd++;
				if (aPath.charAt(i)=='\\')
					back++;
			}
			return (back > fwd) ? true : false
		}


		/*
			Given an AIR file url, will return a File object. Supports eg.
		 "app:/DesktopPathTest.xml"
		 "app-storage:/preferences.xml"
		 "file:///C:/Documents%20and%20Settings/bob/Desktop" (the desktop on Bob's Windows computer)
		 "file:///Users/bob/Desktop" (the desktop on Bob's Mac computer)
			"desktop:/"
			"user:/Desktop"
		*/
		public static function fileFromFancyPath(aPath: String): File {
			var rootName: String = StringUtils.extract(aPath,/^[a-z-]+:/)
			var pathRemainder: String = rootName ? aPath.substring(rootName.length) : aPath
			var file: File
			switch(rootName) {
				case 'desktop:':
					file = File.desktopDirectory.resolvePath(pathRemainder)
				break;
				case 'user:':
					file = File.userDirectory.resolvePath(pathRemainder)
				break;
				case null:
					file = File.applicationDirectory.resolvePath(pathRemainder)
					break;
				case 'app:':
				case 'app-storage:':
				default:
					file = new File(aPath)
				break;
			}
			return file
		}


		public static function ensureDoesntExist(aFile: File): void {
			if (aFile.exists)
				aFile.deleteFile();
		}
	}
}
