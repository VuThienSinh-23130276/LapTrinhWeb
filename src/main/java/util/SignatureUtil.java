package util;

import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.util.Base64;

public class SignatureUtil {

	public static String signData(String data, PrivateKey privateKey) throws Exception {

		Signature signature = Signature.getInstance("SHA256withRSA");

		signature.initSign(privateKey);

		signature.update(data.getBytes());

		byte[] signedBytes = signature.sign();

		return Base64.getEncoder().encodeToString(signedBytes);
	}

	public static boolean verifySignature(String data, String signatureString, PublicKey publicKey) throws Exception {

		Signature signature = Signature.getInstance("SHA256withRSA");

		signature.initVerify(publicKey);

		signature.update(data.getBytes());

		byte[] signatureBytes = Base64.getDecoder().decode(signatureString);

		return signature.verify(signatureBytes);
	}
}