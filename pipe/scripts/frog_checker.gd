extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# 处理刚体进入
	if body is RigidBody2D:
		body.on_body += 1
	
	# 处理玩家进入（造成伤害并触发相机缩放）
	if body.is_in_group("player"):
		get_parent().hurt(body.damage)
		get_tree().root.get_child(0).get_node("Camera2D").zoomer()

func _on_body_exited(body: Node2D) -> void:
	# 处理刚体离开
	if body is RigidBody2D:
		body.on_body -= 1
