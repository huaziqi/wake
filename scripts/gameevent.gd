extends Node2D

signal dna_collected(number:float)#全局变量 
signal ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary)
signal change_decription_sig(upgrade:AbilityUpgrade)
	
func emit_dna_collected(number:float):#碰撞后被拣去，在colliision里第5个是捡dna
	dna_collected.emit(number)
	
func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)	

#func emit_change_description(upgrade:AbilityUpgrade):
	#change_decription_sig.emit(upgrade)
func emit_change_description(weaponid:String):
	change_decription_sig.emit(weaponid)
	
func change_description(upgrade:AbilityUpgrade,dscps:
	Dictionary,index:int):
	upgrade.description=dscps[index]
