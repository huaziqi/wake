extends RigidBody2D

# 基础参数
@export var roll_force: float = 3000.0       # 地面滚动时的力
@export var max_angular_velocity: float = 20.0  # 最大旋转速度
@export var jump_impulse: float = 1200.0   # 跳跃冲量大小（垂直方向）
@export var jump_direction_strength: float = 0.1  # 水平方向弹射比例
@export var jump_cooldown: float = 0.5     # 跳跃冷却时间
@export var fall_acceleration: float = 2000.0  # 按下↓时的下落加速度
@export var start_torque: float = 5000.0    # 启动时的初始倾斜扭矩(原本用于优化正方体滚动）
@export var velocity_threshold: float = 5.0  # 判断"0速"的速度阈值
@export var air_spin_force: float = 500.0   # 空中旋转产生的位移力
@export var ground_check_range: float = 10.0  # 地面检测范围

# 状态变量
var can_jump: bool = true
var last_jump_time: float = 0.0
var is_starting: bool = false

func _physics_process(delta: float) -> void:
	handle_movement()  
	handle_jump()
	handle_fall_acceleration()
	angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity)
	
	# 重置启动状态
	if linear_velocity.length() < velocity_threshold:
		is_starting = false



# 整合地面和空中移动逻辑
func handle_movement() -> void:
	if can_jump == true :
		handle_ground_roll()
	else:
		handle_air_spin()

# 地面滚动逻辑
func handle_ground_roll() -> void:
	if Input.is_action_pressed("ui_left"):
		apply_central_force(Vector2(-roll_force, 0))
		if linear_velocity.length() < velocity_threshold and not is_starting:
			apply_torque(start_torque)
			is_starting = true
		else:
			apply_torque(roll_force * 0.1)
	elif Input.is_action_pressed("ui_right"):
		apply_central_force(Vector2(roll_force, 0))
		if linear_velocity.length() < velocity_threshold and not is_starting:
			apply_torque(-start_torque)
			is_starting = true
		else:
			apply_torque(-roll_force * 0.1)

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
	
	if Input.is_action_just_pressed("ui_up") and can_jump:
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

func enable_jump():
	can_jump=true

func disable_jump():
	can_jump=false
	
