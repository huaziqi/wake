shader_type canvas_item;

uniform float intensity : hint_range(0.0, 30.0);  // 扭曲强度
uniform float mask_radius : hint_range(0.0, 1.0, 0.01) = 0.5; // 圆形半径
uniform float offset : hint_range(0.0, 2.0, 0.01) = 0.5;       // 动态偏移速度

// 计算与中心的距离
float distFromCen(vec2 p) {
    return distance(p, vec2(0.5));
}

// 旋转函数
vec2 rotate(vec2 p, float angle) {
    return vec2(
        cos(angle) * p.x - sin(angle) * p.y,
        sin(angle) * p.x + cos(angle) * p.y
    );
}

void fragment() {
    // 以中心为基准计算距离
    float distMod = distFromCen(UV);
    float angle = intensity * distMod;

    // 将UV平移到中心旋转后再移回
    vec2 newp = rotate(UV - vec2(0.5), angle) + vec2(0.5);

    // 做横向动态偏移
    float a = abs((newp.x - 0.5) * 2.0);
    newp.x = fract(a + offset * TIME);

    // 采样原纹理
    COLOR = texture(TEXTURE, newp);

    // 圆形遮罩：超过半径则透明
    float mask_tex = step(distMod, mask_radius);
    COLOR.a *= mask_tex;
}
