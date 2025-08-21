extends RigidBody2D

# 跳跃参数
@export var b_jump_force: float = 500.0 
@export var jump_force: float = 500.0  
@export var jump_interval: Vector2 = Vector2(0.3, 3.0)  # 间隔范围（min, max）
# 落地检测
var on_ground: bool = false
var on_body: int = 0
@export var torque_strength := 2000.0
# 随机大小
@export var size = randf_range(0.5, 1)
@export var HP: int = size * 1000
@export var is_dead: bool = false

func _ready():
	# 音频音调调整
	var pitch_offset = (1.1 - size) * 1
	$uhahaha.pitch_scale += pitch_offset
	$die.pitch_scale += pitch_offset
	
	randomize()
	schedule_jump()

func _physics_process(delta):

		
	# 应用大小缩放
	scale = Vector2(size, size)
	if not is_dead:
		$CollisionShape2D.scale = Vector2(size, size)
	
	# 死亡检测
	if HP <= 0 and not is_dead:
		die()
		return
		
	# 旋转矫正（施加反向扭矩）
	if rotation != 0 and not is_dead:
		apply_torque(-rotation * torque_strength)
		
		# 防止微小摆动
		if abs(rotation) < 0.01:
			rotation = 0
			angular_velocity = 0

func schedule_jump():
	if is_dead:
		return
		
	$AnimationPlayer.play("ready")
	# 计算随机跳跃延迟
	var delay = jump_interval.x + randf() * (jump_interval.y - jump_interval.x)
	jump_force = b_jump_force * delay
	get_tree().create_timer(delay).timeout.connect(jump)

func jump():
	if (on_ground or on_body) and not is_dead:
		$AnimatedSprite2D.play("jump")
		$AnimationPlayer.play("bounce")
		$uhahaha.play()
		
		# 随机跳跃方向和角度
		var dir = -1.0 if randf() < 0.5 else 1.0  # 50%概率向左
		var angle_rad = deg_to_rad(45.0 + randf() * 30.0)
		
		# 设置跳跃速度
		linear_velocity = Vector2(
			jump_force * dir * cos(angle_rad),  # X方向（左右）
			-jump_force * sin(angle_rad)        # Y方向（向上，负号对应Godot坐标系）
		)
		
		# 翻转精灵
		$AnimatedSprite2D.flip_h = dir == -1
	
	# 重置跳跃力并调度下一次跳跃
	jump_force = b_jump_force    
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.play("idle")
	schedule_jump()

func turn_red():    
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func hurt(damage):
	if is_dead:
		return
		
	$hurt.play()
	HP -= damage
	print(damage)
	turn_red()

func die():
	if is_dead:
		return
		
	is_dead = true
	$CollisionShape2D.queue_free()    
	get_tree().root.get_child(0).add_kills()
	$die.play()
	$AnimationPlayer.play("die")
	$frog_check.queue_free()
	$shadow.queue_free()
	
	await get_tree().create_timer(1.5).timeout
	queue_free()
