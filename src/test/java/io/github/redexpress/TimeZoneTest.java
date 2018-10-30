package io.github.redexpress;

import java.text.SimpleDateFormat;

public class TimeZoneTest {
	public static void main(String[] args) throws Exception {
		System.out.println(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse("2013-09-03T05:18:14Z".replace("Z", "+0800")));
		System.out.println(new SimpleDateFormat("HH:mm:ssZ").parse("00:18:14+0900".replace("Z", "+0800")));
	}
}
