extends shoot_weapon_manager
#@onready var hurricane_gap_timer: Timer = $ShootGapTimer
#var hurricane_gap_time=shoot_gap_time


func _ready() -> void:
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统
	shoot_gap_timer.wait_time = shoot_gap_time
	shoot_gap_timer.start()


	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id=="hurricane":#连接升级系统		

		var precent_reduction=current_upgrades["hurricane"]["quantity"]
		shoot_gap_timer.wait_time=shoot_gap_time*0.8**(precent_reduction)
		print(shoot_gap_time)
		print(shoot_gap_timer.wait_time)
	if upgrade.id=="shoot_weapon":
		var precent_reduction=current_upgrades["shoot_weapon"]["quantity"]
		shoot_gap_time=shoot_gap_time*(1-0.05*precent_reduction)
		shoot_gap_timer.wait_time=(shoot_gap_timer.wait_time)*0.95
		print("全体射击武器基础速度加5%",shoot_gap_time)
		print(shoot_gap_timer.wait_time)
	
