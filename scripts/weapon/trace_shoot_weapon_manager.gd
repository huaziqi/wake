extends shoot_weapon_manager

func init() -> void:
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if(upgrade.id == "trace_weapon_damage"):
		var precent_reduction_damage=current_upgrades["trace_weapon_damage"]["quantity"]
		damage_added=1.0*(1.05**precent_reduction_damage)
		print(damage_added)
	if(upgrade.id == "trace_shoot_weapon_manager"):
		var precent_reduction_damage=current_upgrades["trace_shoot_weapon_manager"]["quantity"]
		shoot_gap_time=3*(0.95**precent_reduction_damage)
