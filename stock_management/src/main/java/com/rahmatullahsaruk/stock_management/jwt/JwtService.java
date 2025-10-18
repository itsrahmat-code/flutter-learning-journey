package com.rahmatullahsaruk.stock_management.jwt;

import com.rahmatullahsaruk.stock_management.repository.TokenRepo;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Date;
import java.util.function.Function;

@Service
public class JwtService {

    @Autowired(required = false)
    private TokenRepo tokenRepo; // যদি ব্ল্যাকলিস্ট/রিভোকশন ইউজ করো

    // এই KEY-টা Base64-encoded 256-bit হওয়া উচিত
    // বর্তমান স্ট্রিংটা যদি Base64 না হয়, নিচের helper দিয়ে নতুনটা জেনারেট করে দাও।
    private static final String SECURITY_KEY_B64 = "6SeHdW3EuWkwbT0PxoJJRt9YOH1uvppoz4C5uhmv0O3zF30YaD";

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECURITY_KEY_B64);
        return Keys.hmacShaKeyFor(keyBytes); // 256-bit key expected
    }

    // helper: নতুন 256-bit key generate করে Base64 আউটপুট (one-time use)
    public static String generateNewBase64Key() {
        byte[] key = new byte[32]; // 256-bit
        new SecureRandom().nextBytes(key);
        return Base64.getEncoder().encodeToString(key);
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parser()
                    .setSigningKey(getSigningKey())
                    .setAllowedClockSkewSeconds(60) // 60s leeway
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            // invalid/expired/malformed token
            throw new IllegalArgumentException("Invalid JWT: " + e.getMessage(), e);
        }
    }

    public <T> T extractClaim(String token, Function<Claims, T> resolver) {
        Claims claims = extractAllClaims(token);
        return resolver.apply(claims);
    }

    public String extractUserName(String token) {
        return extractClaim(token, Claims::getSubject); // email as subject
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    private boolean isTokenExpired(String token) {
        try {
            Date exp = extractExpiration(token);
            return exp.before(new Date());
        } catch (Exception e) {
            // পার্সিং সমস্যা হলে conservative ভাবে expired ধরা নিরাপদ
            return true;
        }
    }

    public boolean isValid(String token, UserDetails user) {
        try {
            String userName = extractUserName(token);
            boolean expired = isTokenExpired(token);

            // OPTIONAL: ব্ল্যাকলিস্ট/রিভোকেশন চেক
            // if (tokenRepo != null && tokenRepo.existsByTokenAndRevokedTrue(token)) return false;

            return userName != null && userName.equals(user.getUsername()) && !expired;
        } catch (Exception e) {
            return false;
        }
    }

    public String extractUserRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }

    public String generateToken(com.rahmatullahsaruk.stock_management.entity.User user) {
        Date now = new Date();
        Date exp = new Date(now.getTime() + 24 * 60 * 60 * 1000L); // 24h

        // ✅ jjwt 0.12.x
        try {
            return Jwts.builder()
                    .setSubject(user.getEmail())
                    .claim("role", user.getRole()) // enum/string; client-side Jwt.parseJwt(token)['role']
                    .setIssuedAt(now)
                    .setExpiration(exp)
                    .signWith(getSigningKey(), Jwts.SIG.HS256) // 0.12.x
                    .compact();
        } catch (NoClassDefFoundError | Exception ignored) {
            // ✅ fallback: jjwt 0.11.x
            return Jwts.builder()
                    .setSubject(user.getEmail())
                    .claim("role", user.getRole())
                    .setIssuedAt(now)
                    .setExpiration(exp)
                    .signWith(getSigningKey()) // 0.11.x
                    .compact();
        }
    }
}
