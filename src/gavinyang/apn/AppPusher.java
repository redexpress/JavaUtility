package gavinyang.apn;

import javapns.back.PushNotificationManager;
import javapns.back.SSLConnectionHelper;
import javapns.data.Device;
import javapns.data.PayLoad;
 
public class AppPusher {
  public static void main(String[] args) throws Exception {
		String deviceToken = "8ff5e49d2079457686fd46275e48c0aae49993c7bf5a4f2a1e0be0097017677f";// token
		String fileName = "/Users/yang/Documents/YangApp.p12";
		String password = "YangApp";
		pushToMyApp(deviceToken, fileName, password);
	}
 
	private static void pushToMyApp(String deviceToken, String certificatePath, String certificatePassword) throws Exception {
		PayLoad payLoad = new PayLoad();
		payLoad.addAlert("This is my test push message");
		payLoad.addBadge(1);    
		payLoad.addSound("default");
 
		PushNotificationManager pushManager = PushNotificationManager
				.getInstance();
		pushManager.addDevice("iPhone", deviceToken);
 
		// Connect to APNs
		/************************************************
		 * Development Server Address£ºgateway.sandbox.push.apple.com /Port: 2195
		 * Production Server Address£ºgateway.push.apple.com /Port: 2195
		 ***************************************************/
		String host = "gateway.sandbox.push.apple.com";
		int port = 2195;
		pushManager.initializeConnection(host, port, certificatePath,
				certificatePassword, SSLConnectionHelper.KEYSTORE_TYPE_PKCS12);
 
		// Send Push
		Device client = pushManager.getDevice("iPhone");
		pushManager.sendNotification(client, payLoad);
		pushManager.stopConnection();
 
		pushManager.removeDevice("iPhone");
		System.out.printf("Done! \n");
	}
}