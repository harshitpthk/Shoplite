package com.shoplite.models;
import java.security.Key;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;


public class Util {
	
private final static java.security.SecureRandom random = new  java.security.SecureRandom();
private static String Algorithm ="AES";
private static String CharSetEncoding ="UTF-8";
private static String SHA = "SHA-1";
public static String KEY_ALGO ="thrhIRI8N0A6H*PAPTasi";
public final static String session_user_header = "shoplite-user-token";
public final static String session_shop_header = "shoplite-shop-token";

public static String generateRandomString(int length) {
		
		String letters = "abcdefghjklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		
		String str = "";
		for (int i=0; i<length; i++)
	    {
			int index =  (int) (random.nextDouble()*letters.length());
			str = str+letters.substring(index,index+1);
	    }
		return str;
	}


public static int generateRandomNumber(int length) {

		int number = random.nextInt();
		
		int maxLimit = 10^length;
		int minLimit = 10^(length-1);
		
		if(number <0)
		{
			number = -(number);
		}
		
		if(number <maxLimit)
		{
			number =number *maxLimit;
		}
		
		while(number<minLimit)
		{
			number= number/10;
		}
		
		return number;
	}

	public static Key getKey() throws Exception {
		byte[] name = KEY_ALGO.getBytes(CharSetEncoding);
		MessageDigest sha = MessageDigest.getInstance(SHA);
		name = sha.digest(name);
		name = Arrays.copyOf(name, 16); 
	    Key key = new SecretKeySpec(name, Algorithm);
	    return key;
	}
	 
	public static String encrypt(String stringValue) throws Exception {
		Key key = getKey();
	    Cipher cipher = Cipher.getInstance(Algorithm);
	    cipher.init(Cipher.ENCRYPT_MODE, key);
	    byte[] value = cipher.doFinal(stringValue.getBytes());
	    String encryptedString = new BASE64Encoder().encode(value);
	    return encryptedString;
	}
	
	public static String decrypt(String stringValue) throws Exception {
		Key key = getKey();
	    Cipher cipher = Cipher.getInstance(Algorithm);
	    cipher.init(Cipher.DECRYPT_MODE, key);
	    byte[] value = new BASE64Decoder().decodeBuffer(stringValue);
	    byte[] decValue = cipher.doFinal(value);
	    String decryptedString = new String(decValue);
	    return decryptedString;
	}
	
	public static String generateSeed(long key,int length) {
		
		Random rand = new Random(key);
		
		String str = "";
		for(int i=0; i<length; ++i) {
			str += (char) (65 + rand.nextInt(26));
		}
		return str;
	}
	
}
