shader_type canvas_item;

uniform vec4 circle_color : source_color = vec4(0.2, 0.6, 0.9, 1.0);
uniform vec2 rect_size = vec2(256.0, 256.0); // 由脚本传入：节点的像素尺寸
uniform vec2 center_ratio = vec2(0.5, 0.5);  // 圆心在节点内的相对位置(0~1)，默认居中
uniform float radius = 100.0;                // 半径（像素）
uniform float edge_softness = 0.0;           // 边缘柔化像素（可选）

void fragment() {
    // 节点本地像素坐标（随节点一起移动缩放）
    vec2 local_px = UV * rect_size;
    vec2 center_px = center_ratio * rect_size;

    float d = distance(local_px, center_px);

    if (edge_softness <= 0.0) {
        if (d <= radius) {
            COLOR = circle_color;
        } else {
            discard;
        }
    } else {
        // 柔边：内圆满色，外圈平滑过渡到透明
        float a = smoothstep(radius, radius - edge_softness, d);
        if (a <= 0.0) { discard; }
        COLOR = vec4(circle_color.rgb, circle_color.a * a);
    }
}
