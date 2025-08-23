extends ShootWeapon

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var death_particles: GPUParticles2D = $GPUParticles2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
var enemy : Enemy
var death_timer : Timer
var dead : bool = false

func _ready() -> void:
	init()
	shoot_gap_time = 0.5
	death_particles.emitting = false
	death_particles.one_shot = true
	death_particles.finished.connect(queue_free)
	
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.wait_time = 3.0
	death_timer.one_shot = true
	death_timer.start()

func set_direction(dir : Vector2) -> void:
	direction = dir

func trace_decision(delta: float) -> void:
	if(dead): #已经死亡，不再移动
		return
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
	while(secure_search_time < 50): #二分查找敌人目标
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

	var to_enemy: Vector2 = (enemy.global_position - global_position).normalized()
	
	# 平滑调整方向（0.0 ~ 1.0，越大转向越快）
	var turn_speed := 5.0
	direction = direction.lerp(to_enemy, turn_speed * delta).normalized()

	# 按新方向前进
	position += direction * shoot_speed * delta

func free_action():
	if(not dead):
		if(player and player.position.distance_to(self.position) > 1500): #当武器距离玩家足够远
			death_animation()
		if(death_timer.time_left == 0):
			death_animation()
			
	
func death_animation() -> void:
	sprite_2d.visible = false
	death_particles.emitting = true
	death_particles.visible = true
	death_particles.restart()
	dead = true
