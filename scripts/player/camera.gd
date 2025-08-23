extends Camera2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("wheel_zoom_up") and zoom.length() < 1.3:
		zoom *= 1.05
	elif Input.is_action_just_pressed("wheel_zoom_down") and zoom.length() > 0.8:
		zoom *= 0.95
