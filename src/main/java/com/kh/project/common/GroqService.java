package com.kh.project.common;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

@Service
public class GroqService {

    @Value("${groq.api.key}")
    private String apiKey;

    @Value("${groq.api.url}")
    private String apiUrl;

    private static final String MODEL = "llama-3.3-70b-versatile";
    private static final long TTL = 1000 * 60 * 10; // 10분

    private final WebClient webClient = WebClient.builder().build();
    private final ObjectMapper mapper = new ObjectMapper();

    // 캐시
    private final Map<String, CacheData> cache = new ConcurrentHashMap<>();

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

    public String generate(String prompt) {

        // 캐시 확인
        CacheData cached = cache.get(prompt);

        if (cached != null) {

            if (!cached.isExpired()) {
                return cached.value;
            }

            // 만료된 캐시 제거
            cache.remove(prompt);

        }

        // 요청 Body
        Map<String, Object> body = Map.of(
                "model", MODEL,
                "messages", List.of(
                        Map.of(
                                "role", "user",
                                "content", prompt)));

        try {

            String result = webClient.post()
                    .uri(apiUrl)
                    .header(HttpHeaders.AUTHORIZATION, "Bearer " + apiKey)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(body)
                    .retrieve()
                    .onStatus(status -> status.value() == 429,
                            response -> Mono.error(
                                    new WebClientResponseException(
                                            429,
                                            "Too Many Requests",
                                            null,
                                            null,
                                            null)))
                    .bodyToMono(String.class)
                    .retryWhen(
                            Retry.backoff(2, Duration.ofSeconds(3))
                                    .filter(throwable ->
                                            throwable instanceof WebClientResponseException &&
                                            ((WebClientResponseException) throwable)
                                                    .getStatusCode()
                                                    .value() == 429))
                    .block();

            String parsed = parse(result);

            cache.put(prompt, new CacheData(parsed, TTL));

            return parsed;

        } catch (WebClientResponseException e) {

            return "AI 서버가 혼잡합니다. 잠시 후 다시 시도해주세요.";

        } catch (Exception e) {

            return "오류 발생 : " + e.getMessage();

        }

    }

    private String parse(String json) {

        try {

            JsonNode root = mapper.readTree(json);
            JsonNode choices = root.path("choices");

            if (!choices.isArray() || choices.size() == 0) {
                return "AI 응답이 없습니다.";
            }

            return choices.get(0)
                    .path("message")
                    .path("content")
                    .asText();

        } catch (Exception e) {

            return "응답 파싱 실패";

        }

    }

}