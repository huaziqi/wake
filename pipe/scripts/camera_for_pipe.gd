extends Camera2D

var is_shaking = false
var shake_time = 0.2  # 抖动持续时间
var shake_strength = 5  # 抖动幅度

func _process(delta):
	if is_shaking:
		# 随机偏移位置实现抖动
		position = Vector2(
			randf_range(-shake_strength, +shake_strength),
			randf_range(-shake_strength, +shake_strength)
		)
		shake_time -= delta
		if shake_time <= 0:
			is_shaking = false
			position=Vector2.ZERO

# 调用这个函数触发抖动
func shake():
	is_shaking = true
	shake_time = 0.5  # 重置时间
func zoomer():
	$AnimationPlayer.play("zoom")


	
