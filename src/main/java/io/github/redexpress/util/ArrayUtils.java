package io.github.redexpress.util;

import java.util.ArrayList;
import java.util.List;

public class ArrayUtils {
	public static List<Integer> range(int from, int to, int step){
		List<Integer> l = new ArrayList<Integer>();
		//TODO
		return l;
	}
	public static List<Integer> range(int from, int to){
		return range(from, to, 1);
	}
	public static List<Integer> range(int to){
		return range(0, to, 1);
	}
}
