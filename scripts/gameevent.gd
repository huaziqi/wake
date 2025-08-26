extends Node2D

signal dna_collected(number:float)#全局变量 
signal ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary)
	
func emit_dna_collected(number:float):#主打一个碰撞后被拣去，在colliision里第5个是捡dna
	dna_collected.emit(number)
	
func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)	
