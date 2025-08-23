extends CharacterBody2D
class_name Enemy

var ACCELRATION : float = 20000
var MAX_SPEED : float = 200
var MAX_HEALTH : float = 1000000
const ENEMY_TYPE : String = "enemy"

var player: Player
var direction : Vector2
var current_health : float

signal enemy_die_signal(enemy_name : String)

func random_dis(minn : int, maxn : int) -> Vector2:
	var dis = randi_range(minn, maxn)
	var rand_vec2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	return rand_vec2 * dis

func _ready() -> void:
	add_to_group("enemy")
	current_health = MAX_HEALTH
	position = player.position - random_dis(1000, 2000)

func _physics_process(delta: float) -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING #避免敌人将玩家看作平台，这样会卡住
	direction = self.position.direction_to(player.position)
	velocity = velocity.move_toward(MAX_SPEED * direction, delta * ACCELRATION)
	check_health()
	move_and_slide()

func check_health() -> void:
	if(current_health <= 0):
		enemy_die_signal.emit(ENEMY_TYPE)
		queue_free()
