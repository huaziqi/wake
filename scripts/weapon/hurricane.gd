extends ShootWeapon

var meet_enemy : bool = false

var enemys : Array[Enemy]

func trace_decision(delta: float) -> void:
	if(not meet_enemy):
		position += delta * direction * shoot_speed
	for enemy in enemys:
		var dir = (global_position - enemy.global_position).normalized()
		var pull_strength = 500.0  # 可调的吸引力度
		enemy.velocity += dir * pull_strength

func _on_hitbox_area_entered(area: Area2D) -> void:
	if "area_name" in area and area.area_name == "hurt_box":
		var enemy : Enemy = area.enemy
		enemys.append(enemy)
		meet_enemy = true

func _on_hitbox_area_exited(area: Area2D) -> void:
	if "area_name" in area and area.area_name == "hurt_box":
		var enemy : Enemy = area.enemy
		enemys.erase(enemy)


func _on_free_timer_timeout() -> void:
	queue_free()
