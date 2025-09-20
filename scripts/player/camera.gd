extends Camera2D

@export var boundary_shape: RectangleShape2D

func _physics_process(delta):
	# 处理缩放
	if Input.is_action_just_pressed("wheel_zoom_up") and zoom.length() < 1.3:
		zoom *= 1.05
	elif Input.is_action_just_pressed("wheel_zoom_down") and zoom.length() > 0.8:
		zoom *= 0.95
	
	# 如果定义了边界形状，则限制相机移动
	if boundary_shape:
		var rect = boundary_shape.get_rect()
		position.x = clamp(position.x, rect.position.x, rect.end.x)
		position.y = clamp(position.y, rect.position.y, rect.end.y)
