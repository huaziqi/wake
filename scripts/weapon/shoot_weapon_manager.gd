extends Node2D
class_name shoot_weapon_manager

@export var weapon : PackedScene
@onready var shoot_gap_timer: Timer = $ShootGapTimer

var player : Player
var graphics : Node2D
var shoot_gap_time : float = 1.0

func init_scene(_player : Player, _graphics : Node) -> void:
	
	player = _player
	graphics = _graphics
	graphics.add_child(self)

func init():
	pass
func _ready() -> void:
	print("ready")
	init()
	shoot_gap_timer.wait_time = shoot_gap_time
	shoot_gap_timer.start()
	
func _on_shoot_gap_timer_timeout() -> void:
	print("okk")
	var new_weapon = weapon.instantiate()
	if("init_scene" in new_weapon):
		new_weapon.init_scene(player, graphics)
		get_tree().current_scene.add_child.call_deferred(new_weapon)
		
