extends Node2D
class_name shoot_weapon_manager

@export var weapon : PackedScene
@onready var shoot_gap_timer: Timer = $ShootGapTimer

var player : Player
var graphics : Node2D
var shoot_gap_time : float = 3
var damage_added : float = 1.0

func init_scene(_player : Player, _graphics : Node) -> void:
	
	player = _player
	graphics = _graphics
	graphics.add_child(self)

func init():
	pass
func _ready() -> void:
	init()
	shoot_gap_timer.wait_time = shoot_gap_time
	shoot_gap_timer.start()
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func _on_shoot_gap_timer_timeout() -> void:
	var new_weapon = weapon.instantiate()
	if("init_scene" in new_weapon):
		new_weapon.init_scene(player, graphics)
		get_tree().current_scene.add_child.call_deferred(new_weapon)
		await new_weapon.ready
		new_weapon.hitbox.real_damage = new_weapon.hitbox.real_damage * damage_added

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	var shoot_gap_level=current_upgrades["shoot_weapon"]["quantity"]
	if upgrade.id!="shoot_weapon":#连接升级系统
		return
	var precent_reduction=current_upgrades["shoot_weapon"]["quantity"]
	shoot_gap_time=shoot_gap_time*(1-0.05*precent_reduction)#"全体射击武器基础速度加5%
	Log.info("升级系统","武器 [%s范围] 成功升级至 Lv.%d 射击时间间隔为为%d" % [upgrade.id,shoot_gap_level,shoot_gap_time])
