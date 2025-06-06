shader_type canvas_item;

uniform float flash_state : hint_range(0.0, 1.5) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float factor = clamp(flash_state, 0.0, 1.0);
    vec3 flash_color = mix(tex_color.rgb, vec3(1.0), factor);
    COLOR = vec4(flash_color, tex_color.a);
}
