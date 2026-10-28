// Slow TokyoNight-coloured aurora drifting behind the text.
// Only pixels close to the background colour are tinted, so text and coloured UI stay crisp.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 term = texture(iChannel0, uv);

    // 1 on empty cells (incl. the faint wallpaper), 0 on text and coloured cells
    float bgMask = 1.0 - smoothstep(0.10, 0.20, distance(term.rgb, iBackgroundColor));

    float t = iTime * 0.05;
    vec2 p = uv * vec2(iResolution.x / iResolution.y, 1.0);
    float band = sin(p.x * 2.0 + t * 3.0 + sin(p.y * 3.0 + t * 2.0) * 1.5)
               + sin(p.y * 4.0 - t * 2.5 + sin(p.x * 1.5 - t) * 2.0);
    band = 0.5 + 0.25 * band;

    vec3 blue = vec3(0.48, 0.64, 0.97);   // #7aa2f7
    vec3 purple = vec3(0.73, 0.60, 0.97); // #bb9af7
    vec3 teal = vec3(0.45, 0.85, 0.80);   // #73daca
    vec3 tint = mix(mix(blue, purple, band), teal, 0.5 + 0.5 * sin(t * 1.7 + p.x));

    fragColor = vec4(mix(term.rgb, tint, 0.10 * band * bgMask), term.a);
}
