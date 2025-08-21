extends Area2D
func _on_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		body.on_ground=false
func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.on_ground=true
		if body.is_in_group("player"):
			$"../../AudioStreamPlayer2D".play()
			$"../../Camera2D".shake()
