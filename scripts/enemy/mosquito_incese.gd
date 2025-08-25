extends Enemy

@export var circle_collision : CollisionShape2D #圆形受击区域,为获取到半径

const ENEMY_BARRAGE = preload("res://scenes/enemy/enemy_barrage.tscn")

var incense_radius : float
var shoot_angle : float
var rotate_rate : float = 10
var begin_rotate_timer : Timer #开始旋转的计时器
var rotate_timer : Timer #一共旋转多少时间
var attack_timer : Timer #攻击间隔

func _ready() -> void:
	init()
	var circle = circle_collision.shape as CircleShape2D
	incense_radius = circle.radius
	
	#初始化Timer
	begin_rotate_timer = Timer.new()
	begin_rotate_timer.one_shot = true
	begin_rotate_timer.wait_time = 1
	add_child(begin_rotate_timer)
	rotate_timer = Timer.new()
	rotate_timer.one_shot = true
	rotate_timer.wait_time = 5
	add_child(rotate_timer)
	attack_timer = Timer.new()
	attack_timer.one_shot = false
	attack_timer.wait_time = 1
	add_child(attack_timer)
	attack_timer.timeout.connect(func():
		var barrage = ENEMY_BARRAGE.instantiate()
		get_tree().current_scene.add_child.call_deferred(barrage)
		barrage.particles.process_material.gravity = Vector3(98 * cos(rotation), 98 * sin(rotation), 0)
		barrage.position = position + Vector2(incense_radius * cos(rotation), incense_radius * sin(rotation))
		barrage.velocity = 0.7
		barrage.direction = Vector2(cos(rotation), sin(rotation))
	)
	
	begin_rotate_timer.timeout.connect( func():
		rotate_timer.start()
		attack_timer.start()
	)
	begin_rotate_timer.start()

func trace_decision(delta : float) -> void:
	#print(begin_rotate_timer.time_left)
	rotate_attack(delta)

func rotate_attack(delta : float) -> void:
	if(rotate_timer.time_left > 0):
		rotate(delta * rotate_rate)
		rotation = rotation if (rotation < 2 * PI) else rotation - 2 * PI 
	elif(rotate_timer.is_stopped() and begin_rotate_timer.is_stopped()):
		begin_rotate_timer.start()
		attack_timer.stop()
		
