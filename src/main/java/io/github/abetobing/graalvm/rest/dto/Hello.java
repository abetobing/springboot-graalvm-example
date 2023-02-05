package io.github.abetobing.graalvm.rest.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Hello {
    String name;
    String message;
    String date;
}
