package com.github.redexpress.ws;

import javax.jws.WebService;

import javax.xml.ws.Endpoint;

@WebService(name = "MyTestWS", serviceName = "MyWebService", targetNamespace = "http://localhost/client")
public class RpcStyleWebServiceImpl implements RpcStypleWebService {

	@Override
	public String echo() {
		return "webservice return msg";
	}

	public static void main(String[] args) {
		Endpoint.publish("http://localhost:8080/MyWebService",
				new RpcStyleWebServiceImpl());
	}

}
