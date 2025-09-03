shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;   // 爆裂进度
uniform float pieces = 8.0;                            // 每轴碎片数量
uniform float explode_px = 180.0;                      // 飞散强度
uniform vec2 gravity_px = vec2(0.0, 500.0);            // 重力
uniform float spin = 10.0;                             // 碎片自旋最大角度
uniform float edge_feather = 0.045;                    // 裂缝羽化
uniform float seed = 3.14159;                          // 随机种子

// ----------------- 小工具 -----------------
float hash11(float p){
    return fract(sin(p*127.1)*43758.5453);
}
vec2 hash21(vec2 p){
    float n = sin(dot(p, vec2(127.1, 311.7)) + seed);
    return fract(vec2(262144.0, 32768.0) * n);
}
vec2 rotate(vec2 p, float a){
    float c = cos(a), s = sin(a);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void fragment(){
    vec2 g = UV * pieces;
    vec2 cell = floor(g);
    vec2 cell_uv = fract(g);

    // 每块碎片随机偏移和缩放
    vec2 rnd = hash21(cell + seed);
    float jitter = (rnd.x - 0.5) * 0.2; // 位置随机偏移
    float scale = 0.8 + 0.2 * rnd.y;    // 缩放随机
    vec2 local = (cell_uv - 0.5) * scale + 0.5 + jitter;

    // 爆炸方向和速度随机化
    float dir_angle = rnd.x * 6.2831853;
    vec2 dir = vec2(cos(dir_angle), sin(dir_angle));
    float speed_factor = 0.8 + 0.4 * rnd.y;

    // 非线性进度
    float t = pow(clamp(progress, 0.0, 1.0), 0.7);

    // 自旋
    float spin_sign = rnd.y*2.0 - 1.0;
    float a = spin * spin_sign * t * t;
    vec2 rotated_local = rotate(local - 0.5, a) + 0.5;

    // 超出边界透明
    if(any(lessThan(rotated_local, vec2(0.0))) || any(greaterThan(rotated_local, vec2(1.0)))){
        COLOR = vec4(0.0);
        return;
    }

    // 爆散位移（像素 -> UV）
    vec2 px_move = dir * explode_px * speed_factor * t + 0.5 * gravity_px * (t*t);
    vec2 uv_move = px_move * TEXTURE_PIXEL_SIZE;

    // 微抖动
    vec2 shake = (hash21(cell + t) - 0.5) * 0.02;
    vec2 shattered_uv = (cell + rotated_local) / pieces + uv_move + shake;

    vec4 col = texture(TEXTURE, shattered_uv);

    // 裂缝边缘 + 噪声
    float edge = min(min(rotated_local.x, rotated_local.y),
                     min(1.0 - rotated_local.x, 1.0 - rotated_local.y));
    float noise = (hash11(cell.x + cell.y*0.7) - 0.5) * 0.05;
    float crack = smoothstep(0.0, edge_feather + noise, edge);

    // 渐隐
    col.a *= crack * (1.0 - t*0.2);

    COLOR = col;
}
