extends Node2D
class_name shoot_weapon_manager

@export var weapon : PackedScene
@onready var shoot_gap_timer: Timer = $ShootGapTimer

var player : Player
var graphics : Node2D
var shoot_gap_time : float = 3

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
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func _on_shoot_gap_timer_timeout() -> void:
	#print("okk")
	var new_weapon = weapon.instantiate()
	if("init_scene" in new_weapon):
		new_weapon.init_scene(player, graphics)
		get_tree().current_scene.add_child.call_deferred(new_weapon)
		
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="shoot_weapon":#连接升级系统
		return

	var precent_reduction=current_upgrades["shoot_weapon"]["quantity"]
	shoot_gap_time=shoot_gap_time*(1-0.05*precent_reduction)
	#print("全体射击武器基础速度加5%",shoot_gap_time)
