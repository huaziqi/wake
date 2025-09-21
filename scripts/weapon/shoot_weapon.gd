extends StaticBody2D
class_name ShootWeapon

var direction : Vector2 = Vector2.ZERO
var shoot_speed : float = 800.0
var player : Player
var shoot_gap_time : float = 1.0
var shoot_gap_timer : Timer = null

@export var hitbox : Area2D

func init():
	pass

func init_scene(_player : Player, _graphics : Node2D):
	player = _player
	set_direction(player.last_direction)
	global_position = player.global_position

func _ready() -> void:
	
	add_to_group("weapon")
	z_index = 100
	init()

func set_direction(dir : Vector2) -> void:
	direction = dir
	rotation = direction.angle() #武器初始方向

func _physics_process(delta: float) -> void:
	trace_decision(delta)
	free_action()
	attack_func()

func trace_decision(delta: float) -> void:
	position += delta * direction * shoot_speed

func free_action():
	if(player and player.position.distance_to(self.position) > 1500): #当武器距离玩家足够远
		queue_free()

func attack_func() -> void:
	pass
	

	
#func _on_attack_shape_area_entered(area: Area2D) -> void:
	#var node = area.get_parent()
	#if(node.is_in_group("enemy")):
		#node.knock_back(2800, direction)
