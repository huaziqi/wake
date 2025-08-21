extends RigidBody2D

# 基础参数
@export var ground_force: float = 3000.0
@export var max_angular_velocity: float = 20.0  # 最大旋转速度
@export var jump_impulse: float = 1200.0   # 跳跃冲量大小（垂直方向）
@export var jump_direction_strength: float = 0.1  # 水平方向弹射比例
@export var jump_cooldown: float = 0.5     # 跳跃冷却时间
@export var fall_acceleration: float = 3500.0  # 按下↓时的下落加速度
@export var start_torque: float = 5000.0    # 启动时的初始倾斜扭矩(原本用于优化正方体滚动）
@export var velocity_threshold: float = 5.0  # 判断"0速"的速度阈值
@export var air_spin_force: float = 500.0   # 空中旋转产生的位移力

# 状态变量
var on_ground: bool = false
var on_body: int = 0
var last_jump_time: float = 0.0
@export var b_damage: float = 200
@export var damage_fix: float = 0.2
var damage: float = b_damage

func _physics_process(delta: float) -> void:
	# 更新伤害数值（根据垂直速度动态调整）
	damage = b_damage + (abs(linear_velocity.y) * damage_fix if linear_velocity.y > 10 else 0)
	# 处理移动、跳跃和下落加速
	handle_movement()  
	handle_jump()
	handle_fall_acceleration()
	
	# 限制最大旋转速度
	angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity)
	


# 整合地面和空中移动逻辑
func handle_movement() -> void:
	if on_ground or on_body:
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

# 跳跃处理逻辑（含冷却判断）
func handle_jump() -> void:
	# 检查跳跃冷却
	if (Time.get_ticks_msec() / 1000.0) - last_jump_time < jump_cooldown:
		return
	
	# 执行跳跃（仅在地面或物体上）
	if Input.is_action_just_pressed("ui_up") and (on_ground or on_body):
		# 计算水平方向（左/右）
		var horizontal_dir: float = 0.0
		if Input.is_action_pressed("ui_left"):
			horizontal_dir = -1.0
		elif Input.is_action_pressed("ui_right"):
			horizontal_dir = 1.0
		
		# 构建跳跃向量（水平方向按比例分配冲量）
		var jump_vector: Vector2 = Vector2(
			horizontal_dir * jump_impulse * jump_direction_strength,
			-jump_impulse  # 垂直方向向上（负号对应Godot坐标系）
		)
		
		apply_impulse(jump_vector)
		last_jump_time = Time.get_ticks_msec() / 1000.0
		apply_torque(horizontal_dir * jump_impulse * 0.05)  # 跳跃时附加旋转扭矩

# 下落加速逻辑（按下↓时）
func handle_fall_acceleration() -> void:
	if Input.is_action_pressed("ui_down"):
		apply_central_force(Vector2(0, fall_acceleration))
