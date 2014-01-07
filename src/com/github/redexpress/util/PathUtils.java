package com.github.redexpress.util;

import java.io.File;

public class PathUtils {
	public static String expanduser(String path) {

		if (path.equals("~") || path.startsWith("~" + File.separator)) {
			return System.getProperty("user.home") + path.substring(1);
		}
		return path;
	}
}
