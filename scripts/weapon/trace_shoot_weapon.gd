extends ShootWeapon

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var enemy : Enemy

func trace_decision(delta: float) -> void:
	if(enemy == null):
		find_enemy()
		if(enemy == null):
			position += delta * direction * shoot_speed
		else:
			search_way(delta)
	else:
		search_way(delta)

func find_enemy():
	var l : float = 0
	var r : float = 500
	var circle = collision_shape_2d.shape as CircleShape2D
	circle.radius = r
	if(area_2d.enemy_num == 0):
		return
	var secure_search_time = 0
	while(secure_search_time < 50):
		secure_search_time += 1
		#print("l, r: ", l, " ", r)
		var mid = (l + r) / 2
		circle.radius = mid
		if(area_2d.enemys.size() > 0 and area_2d.enemys.size() < 5):
			enemy = area_2d.get_closest()
			return
		if(area_2d.enemys.size() == 0):
			l = mid
		elif(area_2d.enemys.size() >= 5):
			r = mid

func search_way(delta: float) -> void:
	if enemy == null or not is_instance_valid(enemy):
		# 敌人没了就继续原方向
		position += direction * shoot_speed * delta
		return

	# 子弹当前位置 → 敌人方向
	var to_enemy: Vector2 = (enemy.global_position - global_position).normalized()
	
	# 平滑调整方向（0.0 ~ 1.0，越大转向越快）
	var turn_speed := 5.0
	direction = direction.lerp(to_enemy, turn_speed * delta).normalized()

	# 按新方向前进
	position += direction * shoot_speed * delta
