package com.hr.helpers;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public interface PasswordEncoder {
    String encode(String password);
    
    static PasswordEncoder getInstance() throws NoSuchAlgorithmException {
        return new Md5Encoder();
    }
}

class Md5Encoder implements PasswordEncoder {
    private final MessageDigest encoder;  
    
    Md5Encoder() throws NoSuchAlgorithmException {
        encoder = MessageDigest.getInstance("MD5");
    }
    @Override
    public String encode(String password) {
        byte[] bytes = password.getBytes();
        bytes = encoder.digest(bytes);
        return new String(bytes);
    }
    
}


