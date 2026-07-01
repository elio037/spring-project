package kr.ac.kopo.member.social;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 카카오 로그인 처리 (OAuth 2.0).
 *  1) 인가 코드 → 액세스 토큰 교환
 *  2) 액세스 토큰 → 사용자 정보(id, 닉네임) 조회
 * Spring Security 없이 JDK HttpClient + Jackson 만으로 구현.
 */
@Service
public class KakaoService {

    @Value("${kakao.rest-api-key}")
    private String restApiKey;

    @Value("${kakao.redirect-uri}")
    private String redirectUri;

    private final HttpClient http = HttpClient.newHttpClient();
    private final ObjectMapper om = new ObjectMapper();

    /** 사용자를 보낼 카카오 로그인(인가) 페이지 URL */
    public String authorizeUrl() {
        return "https://kauth.kakao.com/oauth/authorize?response_type=code"
                + "&client_id=" + enc(restApiKey)
                + "&redirect_uri=" + enc(redirectUri);
    }

    /** 인가 코드로 액세스 토큰을 발급받는다 */
    public String getAccessToken(String code) throws Exception {
        String body = "grant_type=authorization_code"
                + "&client_id=" + enc(restApiKey)
                + "&redirect_uri=" + enc(redirectUri)
                + "&code=" + enc(code);

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create("https://kauth.kakao.com/oauth/token"))
                .header("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> res = http.send(req, BodyHandlers.ofString());
        JsonNode node = om.readTree(res.body());
        if (node.get("access_token") == null) {
            throw new IllegalStateException("토큰 발급 실패: " + res.body());
        }
        return node.get("access_token").asText();
    }

    /** 액세스 토큰으로 카카오 사용자 정보를 조회한다 (providerId, nickname) */
    public KakaoUser getUserInfo(String accessToken) throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create("https://kapi.kakao.com/v2/user/me"))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .build();

        HttpResponse<String> res = http.send(req, BodyHandlers.ofString());
        JsonNode node = om.readTree(res.body());
        if (node.get("id") == null) {
            throw new IllegalStateException("사용자 정보 조회 실패: " + res.body());
        }

        String providerId = node.get("id").asText();
        String nickname = node.path("kakao_account").path("profile").path("nickname").asText(null);
        if (nickname == null) {
            nickname = node.path("properties").path("nickname").asText(null);
        }
        return new KakaoUser(providerId, nickname);
    }

    private String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }

    /** 카카오 사용자 정보 DTO */
    public record KakaoUser(String providerId, String nickname) {}
}
