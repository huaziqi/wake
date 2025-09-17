extends Control

@export var wave_label: Label 
var tween: Tween

# 动画总时长可微调
const SLIDE_DURATION := 0.9
const HOLD_DURATION := 1.2

func _physics_process(delta: float) -> void:
	pass

func show_wave(n: int) -> void:
	if not is_instance_valid(wave_label):
		return

	# 若正在播放，直接中断重来
	if tween and tween.is_valid():
		tween.kill()

	# 把 Label 先放到屏幕右侧外边
	var screen_w := get_viewport_rect().size.x
	var label_w := wave_label.size.x
	wave_label.position.x = screen_w

	# 设置文本
	wave_label.text = "Wave %d" % n
	wave_label.visible = true

	# 创建新 Tween
	tween = create_tween().bind_node(self)

	# 1) 滑入到正中间
	var center_x := (screen_w - label_w) * 0.5
	
	tween.tween_property(wave_label, "position:x", center_x, SLIDE_DURATION)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 2) 停顿
	tween.tween_interval(HOLD_DURATION)

	# 3) 滑回右侧外边
	tween.tween_property(wave_label, "position:x", screen_w, SLIDE_DURATION)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# 4) 可选：动画结束后隐藏
	#tween.tween_callback(func(): wave_label.hide())
	#
