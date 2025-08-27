extends Node
@export var bullet:PackedScene

var base_wait_time

func _ready() -> void:
	base_wait_time=$Timer.wait_time
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统

func _on_timer_timeout() -> void:
	var targets=get_parent().targets
	if targets.size()!=0:
		shoot()
func shoot():
	var shooted_bullet=bullet.instantiate()
	shooted_bullet.rotation_angle=get_parent().rotation_angle
	shooted_bullet.base_position=get_parent().global_position
	get_tree().root.get_child(0).add_child(shooted_bullet)
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="cannon_quickness":#连接升级系统
		return
	print($Timer.wait_time )
	var precent_reduction=current_upgrades["cannon_quickness"]["quantity"]
	$Timer.wait_time=base_wait_time*0.8**(precent_reduction)
	#$Timer.start()

	
		
