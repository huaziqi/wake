extends CharacterBody2D
class_name Enemy

@export var health_bar: TextureProgressBar
@export var eased_progress: TextureProgressBar

const DNA = preload("res://scenes/dna/dna.tscn")

var ACCELRATION : float = 20000
var MAX_SPEED : float = 150
var MAX_HEALTH : float = 50
const ENEMY_TYPE : String = "enemy"

var player: Player
var direction : Vector2
var current_health : float
var current_max_health : float

signal enemy_die_signal(enemy_name : String)

func random_dis(minn : int, maxn : int) -> Vector2:
	var dis = randi_range(minn, maxn)
	var rand_vec2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	return rand_vec2 * dis

func _ready() -> void:
	init()

func init() -> void:
	add_to_group("enemy")
	current_health = MAX_HEALTH
	current_max_health = MAX_HEALTH
	position = player.position - random_dis(1000, 2000)

func _physics_process(delta: float) -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING #避免敌人将玩家看作平台，这样会卡住
	trace_decision(delta)
	check_health()
	

func trace_decision(delta : float) -> void:
	direction = self.position.direction_to(player.position)
	velocity = velocity.move_toward(MAX_SPEED * direction, delta * ACCELRATION)
	move_and_slide()

func check_health() -> void:
	if(current_health <= 0):
		enemy_die_signal.emit(ENEMY_TYPE)
		death_drops()

func health_update() -> void:
	var percent : float = max(current_health / current_max_health, 0)
	health_bar.value = percent
	create_tween().tween_property(eased_progress, "value", percent, 0.3)

func death_drops() -> void:
	var dna = DNA.instantiate()
	get_tree().current_scene.add_child(dna)
	dna.position = position
	queue_free()
