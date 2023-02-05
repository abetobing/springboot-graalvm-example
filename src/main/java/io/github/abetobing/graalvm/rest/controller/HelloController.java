package io.github.abetobing.graalvm.rest.controller;

import io.github.abetobing.graalvm.rest.dto.Hello;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@RestController
@RequestMapping("/hello")
public class HelloController {

    @GetMapping
    public ResponseEntity<Hello> home() {
        return ResponseEntity.ok(new Hello("Abe", "Nice to meet you", Instant.now().toString()));
    }

}
