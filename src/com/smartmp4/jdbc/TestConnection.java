package com.smartmp4.jdbc;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestConnection {
	String databaseName;
	String username;
	String password;
	String host = "127.0.0.1";
	String url = "";

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public TestConnection(String databaseName, String username, String password) {
		super();
		this.databaseName = databaseName;
		this.username = username;
		this.password = password;
	}

	public TestConnection(String databaseName, String username, String password, String host) {
		super();
		this.databaseName = databaseName;
		this.username = username;
		this.password = password;
		this.host = host;
	}

	public TestConnection(String url) {
		super();
		this.url = url;
	}

	public String connectOdbc() throws Exception {
		String theUrl = (url != null) ? url : String.format("jdbc:odbc:%s", databaseName);
		Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		return getDatabaseInfo(theUrl);
	}

	public String connectOracle() throws Exception {
		String theUrl = (url != null) ? url : String.format("jdbc:oracle:thin:@%s:1521:%s", host, databaseName);
		Class.forName("oracle.jdbc.driver.OracleDriver");
		return getDatabaseInfo(theUrl);
	}

	private String getDatabaseInfo(String theUrl) throws SQLException {
		Connection conn = DriverManager.getConnection(theUrl, username, password);
		DatabaseMetaData meta = conn.getMetaData();
		return meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion();
	}
}
