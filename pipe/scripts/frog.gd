extends RigidBody2D

# 跳跃参数
@export var b_jump_force: float = 500.0 
@export var jump_force: float = 500.0  
@export var jump_interval: Vector2 = Vector2(0.3, 3.0)  # 间隔范围（min, max）
# 落地检测
var on_ground:bool = false
var on_body:int = 0
@export var torque_strength := 2000.0
# 随机大小
@export var size=randf_range(0.5,1)
@export var HP:int=size*1000
@export var is_dead:bool =false
func _ready():
	get_node("uhahaha").pitch_scale+=(1.1-size)*1
	get_node("die").pitch_scale+=(1.1-size)*1
	randomize()
	schedule_jump()
func _physics_process(delta):
	if not is_dead:
		scale=Vector2(size,size)
		get_node("CollisionShape2D").scale=Vector2(size,size)#如果只改了整体scale collision貌似没改，先写着。
	if HP<=0 and not is_dead:
		die()
	# 当旋转不为 0 时，施加反向扭矩
	if rotation != 0:
		# 根据当前旋转方向，施加相反方向的扭矩（让它减速并回正）
		apply_torque(-rotation * torque_strength)
		
		# 旋转接近 0 时停止扭矩（避免来回摆动）
		if abs(rotation) < 0.01:
			rotation=0
			angular_velocity = 0  # 清除角速度，防止微小摆动


func schedule_jump():
		if not is_dead:
			$AnimationPlayer.play("ready")
			var delay = jump_interval.x + randf() * (jump_interval.y - jump_interval.x)
			jump_force=b_jump_force*delay
			get_tree().create_timer(delay).timeout.connect(jump)
		
		
	

func jump():
	if (on_ground or on_body) and not is_dead:
		$AnimatedSprite2D.play("jump")
		$AnimationPlayer.play("bounce")
		get_node("uhahaha").play()
		var is_left = randf() < 0.5  # 50%概率向左
		var dir = -1.0 if is_left else 1.0
		var angle_deg = 45.0 + randf() * 30.0
		var angle_rad = deg_to_rad(angle_deg)
		var velocity = Vector2(
			jump_force * dir*cos(angle_rad),  # X方向（左右）
			-jump_force * sin(angle_rad)  # Y方向（向上，负号对应Godot坐标系）
		)
		if dir==-1:
			$AnimatedSprite2D.flip_h=true
		else:
			$AnimatedSprite2D.flip_h=false
		linear_velocity = velocity
	jump_force=b_jump_force	
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.play("idle")
	schedule_jump()
func turn_red():	
	$AnimatedSprite2D.modulate=Color(1,0,0)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate=Color(1,1,1)
func hurt(damage):
	if not is_dead:
		get_node("hurt").play()
		HP-=damage
		print(damage)
		turn_red()
func die():
	is_dead=true
	get_node("CollisionShape2D").queue_free()	
	get_tree().root.get_child(0).add_kills()
	get_node("die").play()
	$AnimationPlayer.play("die")
	get_node("frog_check").queue_free()
	get_node("shadow").queue_free()
	await get_tree().create_timer(1.5).timeout
	queue_free()

	
	
