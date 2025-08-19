extends RigidBody2D

# 基础参数
@export var ground_force:  = 3000.0
@export var max_angular_velocity: float = 20.0  # 最大旋转速度
@export var jump_impulse: float = 1200.0   # 跳跃冲量大小（垂直方向）
@export var jump_direction_strength: float = 0.1  # 水平方向弹射比例
@export var jump_cooldown: float = 0.5     # 跳跃冷却时间
@export var fall_acceleration: float = 3000.0  # 按下↓时的下落加速度
@export var start_torque: float = 5000.0    # 启动时的初始倾斜扭矩(原本用于优化正方体滚动）
@export var velocity_threshold: float = 5.0  # 判断"0速"的速度阈值
@export var air_spin_force: float = 500.0   # 空中旋转产生的位移力
@export var ground_check_range: float = 10.0  # 地面检测范围

# 状态变量
var on_ground: bool = false
var on_body: int = 0
var last_jump_time: float = 0.0
var is_starting: bool = false
@export var b_damage:float=200
@export var damage_fix:float=0.2
var damage:float=b_damage
func _physics_process(delta: float) -> void:
	#伤害数值跟踪
	if linear_velocity.y>10:
		damage=b_damage+abs(linear_velocity.y*damage_fix)
	else:
		damage=b_damage	
	handle_movement()  
	handle_jump()
	handle_fall_acceleration()
	angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity)
	
	# 重置启动状态
	if linear_velocity.length() < velocity_threshold:
		is_starting = false



# 整合地面和空中移动逻辑
func handle_movement() -> void:
	if on_ground or on_body :
		handle_ground()
	else:
		handle_air_spin()

# 地面滚动逻辑
func handle_ground() -> void:
	if Input.is_action_pressed("ui_left"):
		apply_central_force(Vector2(-ground_force, 0))
		
		
			
	elif Input.is_action_pressed("ui_right"):
		apply_central_force(Vector2(ground_force, 0))


# 空中旋转产生位移逻辑
func handle_air_spin() -> void:
	if Input.is_action_pressed("ui_left"):
		apply_torque(start_torque * 5)  
		apply_central_force(Vector2(-air_spin_force, 0))  
	elif Input.is_action_pressed("ui_right"):
		apply_torque(-start_torque * 5)
		apply_central_force(Vector2(air_spin_force, 0))

func handle_jump() -> void:
	if Time.get_ticks_msec() / 1000.0 - last_jump_time < jump_cooldown:
		return
	
	if Input.is_action_just_pressed("ui_up") and (on_ground or on_body):
		var horizontal_dir: float = 0.0
		if Input.is_action_pressed("ui_left"):
			horizontal_dir = -1.0
		elif Input.is_action_pressed("ui_right"):
			horizontal_dir = 1.0
		
		var jump_vector: Vector2 = Vector2(
			horizontal_dir * jump_impulse * jump_direction_strength,
			-jump_impulse
		)
		
		apply_impulse(jump_vector)
		last_jump_time = Time.get_ticks_msec() / 1000.0
		apply_torque(horizontal_dir * jump_impulse * 0.05)

func handle_fall_acceleration() -> void:
	if Input.is_action_pressed("ui_down"):
		apply_central_force(Vector2(0, fall_acceleration))
