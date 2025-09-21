extends Node
class_name Cannon_Shooter
@export var bullet:PackedScene
@export var cannon : Cannon

var base_wait_time
@export var timer : Timer

func _ready() -> void:
	base_wait_time = timer.wait_time
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统

func _on_timer_timeout() -> void:
	var targets=cannon.targets
	if targets.size()!=0:
		shoot()
func shoot():
	if(not cannon):
		return
	var shooted_bullet=bullet.instantiate()
	get_tree().current_scene.add_child.call_deferred(shooted_bullet)
	shooted_bullet.rotation_angle = cannon.rotation_angle
	shooted_bullet.base_position = cannon.global_position
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="cannon_quickness":#连接升级系统
		return
	var precent_reduction=current_upgrades["cannon_quickness"]["quantity"]
	$Timer.wait_time=base_wait_time*0.8**(precent_reduction)
	#$Timer.start()

	
		
