extends CharacterBody2D
class_name Enemy

@export var health_bar: TextureProgressBar
@export var eased_progress: TextureProgressBar


const DNA = preload("res://scenes/dna/dna.tscn")
@onready var hurtbox: enemy_hurtbox = $graphics/hurtbox
@onready var hitbox: enemy_hitbox = $graphics/hitbox
@onready var sprite_2d: Sprite2D = $graphics/Sprite2D
@onready var ui: Control = $UI

var ACCELRATION : float = 20000
var MAX_SPEED : float = 150
var MAX_HEALTH : float = 100
var ENEMY_TYPE : String

var death_time : float = 1.0 #死亡时间 因为死亡之后还有分解动画，亡语等等

var player: Player
var master: Master
var direction : Vector2
var current_health : float
var current_max_health : float

var has_dropped : bool = false
var has_dead : bool = false


signal enemy_die_signal(enemy_name : String)

func get_enemy_type() -> void:
	ENEMY_TYPE = get_script().resource_path.get_file().get_basename()
	

func random_dis(minn : int, maxn : int) -> Vector2:
	var dis = randi_range(minn, maxn)
	var rand_vec2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	return rand_vec2 * dis

func _ready() -> void:
	add_to_group("enemy")
	get_enemy_type()
	current_health = MAX_HEALTH
	current_max_health = MAX_HEALTH
	position = player.position - random_dis(1000, 2000)
	init()

func init() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING #避免敌人将玩家看作平台，这样会卡住
	trace_decision(delta)
	attack_event(delta)
	check_health()

func attack_event(delta : float) -> void:
	pass	

func trace_decision(delta : float) -> void:
	if(not has_dead):
		var target : Node = master if is_in_group("master_enemy") else player
		direction = self.position.direction_to(target.position)
		velocity = velocity.move_toward(MAX_SPEED * direction, delta * ACCELRATION)
		move_and_slide()

func check_health() -> void:
	if(current_health <= 0):
		before_dead()
		
func before_dead() -> void:
	if(not has_dead):
		enemy_die_signal.emit(ENEMY_TYPE)
		has_dead = true
	death_drops()
	death_event()

func death_event() -> void: #亡语
	sprite_2d.visible = false
	ui.visible = false
	hitbox.monitorable = false
	hitbox.monitoring = false
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	death_anime()
	get_tree().create_timer(death_time, false).timeout.connect(Callable(self, "queue_free"))
	extend_death_event()
	
func death_anime() -> void:
	pass
	
func extend_death_event() -> void:
	pass

func death_drops() -> void:
	if(has_dropped):
		return
	has_dropped = true
	var dna = DNA.instantiate()
	get_tree().current_scene.add_child(dna)
	dna.position = position
	
func health_update() -> void:
	var percent : float = max(current_health / current_max_health, 0)
	health_bar.value = percent
	create_tween().tween_property(eased_progress, "value", percent, 0.2)
