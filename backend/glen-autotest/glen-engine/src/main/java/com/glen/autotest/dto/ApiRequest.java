package com.glen.autotest.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * API请求DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApiRequest {
    private String base;
    private String path;
    private String method;
    private String query;
    private String header;
    private String body;
    private String bodyType;
}
