extends Area2D
func _on_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		body.disable_jump()		
func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.enable_jump()
		$"../../AudioStreamPlayer2D".play()
		$"../../Camera2D".shake()
