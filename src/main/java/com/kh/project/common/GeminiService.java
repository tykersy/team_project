package com.kh.project.common;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    // =========================
    // 🚀 WebClient (1회 생성)
    // =========================
    private final WebClient webClient = WebClient.builder().build();

    private final ObjectMapper mapper = new ObjectMapper();

    // =========================
    // 🚀 Rate Limit (5초 제한)
    // =========================
    private static long lastCallTime = 0;
    private static final long MIN_INTERVAL = 5000;

    // =========================
    // 🚀 Cache (TTL 포함)
    // =========================
    private final Map<String, CacheData> cache = new ConcurrentHashMap<>();
    private static final long TTL = 1000 * 60 * 10; // 10분

    // =========================
    // 🚀 캐시 데이터 클래스
    // =========================
    private static class CacheData {
        String value;
        long expireTime;

        CacheData(String value, long ttlMillis) {
            this.value = value;
            this.expireTime = System.currentTimeMillis() + ttlMillis;
        }

        boolean isExpired() {
            return System.currentTimeMillis() > expireTime;
        }
    }

    // =========================
    // 🚀 메인 호출 메서드
    // =========================
    public String generate(String prompt) {

        // 1️⃣ 캐시 확인
        CacheData cached = cache.get(prompt);
        if (cached != null && !cached.isExpired()) {
            return cached.value;
        }
        if (cached != null && cached.isExpired()) {
            cache.remove(prompt);
        }

        // 2️⃣ Rate Limit (429 방지 핵심)
        if (System.currentTimeMillis() - lastCallTime < MIN_INTERVAL) {
            return "⏳ 잠시 후 다시 시도하세요 (API 호출 제한)";
        }
        lastCallTime = System.currentTimeMillis();

        // 3️⃣ Retry 로직
        int retry = 3;

        while (retry-- > 0) {
            try {
                Map<String, Object> body = Map.of(
                        "contents", List.of(
                                Map.of(
                                        "parts", List.of(
                                                Map.of("text", prompt)
                                        )
                                )
                        )
                );

                String response = webClient.post()
                        .uri(apiUrl + "?key=" + apiKey)
                        .bodyValue(body)
                        .retrieve()
                        .bodyToMono(String.class)
                        .block();

                String result = parse(response);

                // 4️⃣ 캐시에 저장
                cache.put(prompt, new CacheData(result, TTL));

                return result;

            } catch (Exception e) {
                try {
                    Thread.sleep(1000L * (3 - retry));
                } catch (InterruptedException ignored) {}

                if (retry == 0) {
                    return "AI 오류: " + e.getMessage();
                }
            }
        }

        return "AI 실패";
    }

    // =========================
    // 🚀 응답 파싱
    // =========================
    private String parse(String json) {
        try {
            JsonNode root = mapper.readTree(json);

            return root.path("candidates")
                    .get(0)
                    .path("content")
                    .path("parts")
                    .get(0)
                    .path("text")
                    .asText();

        } catch (Exception e) {
            return "응답 파싱 실패";
        }
    }
}