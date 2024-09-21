shader_type canvas_item;

uniform vec2 resolution = vec2(1024.0, 600.0);
uniform vec2 light_direction = vec2(0.5, -0.5); // Direction of the sunlight
uniform float shadow_strength = 0.5; // Strength of the shadows
uniform float cloud_height = 1000.0; // Simulated height of the clouds

// Constants
const float CLOUD_COVERAGE = 0.64;
const float CLOUD_DETAIL_COVERAGE = 0.16;
const float CLOUD_SPEED = 1.6;
const float CLOUD_DETAIL_SPEED = 4.8;

float hash12(vec2 p) {
    uvec2 q = uvec2(ivec2(p)) * uvec2(1597334673u, 3812015801u);
    uint n = (q.x ^ q.y) * 1597334673u;
    return float(n) * (1.0 / float(0xffffffffu));
}

vec2 hash22(vec2 p) {
    uvec2 q = uvec2(ivec2(p)) * uvec2(1597334673u, 3812015801u);
    q = (q.x ^ q.y) * uvec2(1597334673u, 3812015801u);
    return vec2(q) * (1.0 / float(0xffffffffu));
}

float remap(float x, float a, float b, float c, float d) {
    return (((x - a) / (b - a)) * (d - c)) + c;
}

// Noise functions
float perlin_noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

    float a = hash12(i);
    float b = hash12(i + vec2(1.0, 0.0));
    float c = hash12(i + vec2(0.0, 1.0));
    float d = hash12(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 curl_noise(vec2 uv) {
    vec2 eps = vec2(0.0, 1.0);
    
    float n1, n2, a, b;
    n1 = perlin_noise(uv + eps);
    n2 = perlin_noise(uv - eps);
    a = (n1 - n2) / (2.0 * eps.y);
    
    n1 = perlin_noise(uv + eps.yx);
    n2 = perlin_noise(uv - eps.yx);
    b = (n1 - n2) / (2.0 * eps.y);
    
    return vec2(a, -b);
}

float worley_noise(vec2 uv, float freq, float t, bool curl) {
    uv *= freq;
    uv += t + (curl ? curl_noise(uv * 2.0) : vec2(0.0));
    
    vec2 id = floor(uv);
    vec2 gv = fract(uv);
    
    float min_dist = 100.0;
    for (float y = -1.0; y <= 1.0; ++y) {
        for (float x = -1.0; x <= 1.0; ++x) {
            vec2 offset = vec2(x, y);
            vec2 h = hash22(id + offset) * 0.8 + 0.1;
            h += offset;
            vec2 d = gv - h;
            min_dist = min(min_dist, dot(d, d));
        }
    }
    
    return min_dist;
}

float perlin_fbm(vec2 uv, float freq, float t) {
    uv *= freq;
    uv += t;
    float amp = 0.5;
    float noise = 0.0;
    for (int i = 0; i < 8; ++i) {
        noise += amp * perlin_noise(uv);
        uv *= 1.9;
        amp *= 0.55;
    }
    return noise;
}

vec4 worley_fbm(vec2 uv, float freq, float t, bool curl) {
    float worley0 = 0.0;
    if (freq < 4.0)
        worley0 = 1.0 - worley_noise(uv, freq * 1.0, t * 1.0, false);
    float worley1 = 1.0 - worley_noise(uv, freq * 2.0, t * 2.0, curl);
    float worley2 = 1.0 - worley_noise(uv, freq * 4.0, t * 4.0, curl);
    float worley3 = 1.0 - worley_noise(uv, freq * 8.0, t * 8.0, curl);
    float worley4 = 1.0 - worley_noise(uv, freq * 16.0, t * 16.0, curl);
    
    float fbm0 = (freq > 4.0 ? 0.0 : worley0 * 0.625 + worley1 * 0.25 + worley2 * 0.125);
    float fbm1 = worley1 * 0.625 + worley2 * 0.25 + worley3 * 0.125;
    float fbm2 = worley2 * 0.625 + worley3 * 0.25 + worley4 * 0.125;
    float fbm3 = worley3 * 0.75 + worley4 * 0.25;
    return vec4(fbm0, fbm1, fbm2, fbm3);
}

float clouds(vec2 uv, float t) {
    float coverage = hash12(vec2(uv.x * (resolution.x / resolution.y), uv.y)) *
        0.1 + ((clamp(CLOUD_COVERAGE, 0.0, 1.0) * 1.6) * 0.5 + 0.5);
    float pfbm = perlin_fbm(uv, 2.0, t);
    vec4 wfbm_low_freq = worley_fbm(uv, 1.6, t * CLOUD_SPEED, false);
    vec4 wfbm_high_freq = worley_fbm(uv, 8.0, t * CLOUD_DETAIL_SPEED, true);
    float perlin_worley = remap(abs(pfbm * 2.0 - 1.0),
                               1.0 - wfbm_low_freq.r, 1.0, 0.0, 1.0);
    perlin_worley = remap(perlin_worley, 1.0 - coverage, 1.0, 0.0, 1.0) * coverage;
    float worley_low_freq = wfbm_low_freq.g * 0.625 + wfbm_low_freq.b * 0.25
        + wfbm_low_freq.a * 0.125;
    float worley_high_freq = wfbm_high_freq.g * 0.625 + wfbm_high_freq.b * 0.25
        + wfbm_high_freq.a * 0.125;
    float c = remap(perlin_worley, (worley_low_freq - 1.0) * 0.64, 1.0, 0.0, 1.0);
    c = remap(c, worley_high_freq * CLOUD_DETAIL_COVERAGE, 1.0, 0.0, 1.0);
    return max(0.0, c);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / resolution.y;
    float t = mod(TIME + 600.0, 7200.0) * 0.03;
    
    
    vec2 shadow_offset = light_direction * (cloud_height / resolution.y);
    vec2 shadow_uv = uv + shadow_offset;
   
    float shadow_density = clouds(shadow_uv, t);
   
    vec3 ground_color = vec3(0.2, 0.1, 0.1); // Sandy ground color
    vec3 shadow_color = ground_color * (1.0 - shadow_density * shadow_strength);
    
    COLOR = vec4(shadow_color, 1.0);
}