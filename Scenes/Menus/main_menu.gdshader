shader_type canvas_item;

uniform vec4 color_from : source_color;
uniform vec4 color_to : source_color;

void fragment() {
    COLOR = mix(color_from, color_to, UV.y); // 从上到下渐变
}
