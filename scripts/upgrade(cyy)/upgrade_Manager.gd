extends Node

@export var upgrade_pool:Array[AbilityUpgrade]
@export var dna_manager:Node
@export var upgrade_scene:PackedScene


var current_upgrades={} #储存已经升级的相关所有数据

func _ready():
	dna_manager.level_up.connect(on_level_up)
	
func pick_upgrades():
	var total_chosen_upgrades:Array[AbilityUpgrade]=[]#用实现卡牌互不相同
	
	var filtered_upgrades=upgrade_pool.duplicate()
	#判定最大等级
	filtered_upgrades=filtered_upgrades.filter(func(upgrade):
		if not current_upgrades.has(upgrade.id):
			return true
		var current_qty = current_upgrades[upgrade.id]["quantity"]
		if current_qty>=upgrade.max_chosen_time:
			return false
		return true
	)
	for i in 3:
		var chosen_upgrade=filtered_upgrades.pick_random() as AbilityUpgrade   #如果返回true则保留括号内的参数                                #随机生成能力卡牌
		total_chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades=filtered_upgrades.filter(func(upgrade): 
			#判定同一次出卡是否出现重复
			if upgrade.id==chosen_upgrade.id:
				return false
			return true
			) 
	return total_chosen_upgrades	
		
	
func on_level_up(current_level:int): 
	var upgrade_screen_instance=upgrade_scene.instantiate()         #将升级界面实例化（场景化）
	add_child(upgrade_screen_instance) 	        #加入到子节点
	var chosen_upgrades=pick_upgrades()
	upgrade_screen_instance.set_card_data_ui(chosen_upgrades as Array[AbilityUpgrade])       #
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)           #在upgrade_screen里有相关介绍
	
	
func apply_upgrade(upgrade:AbilityUpgrade):          
	var has_upgrades=current_upgrades.has(upgrade.id)         #获取已经升级的数据对应的id
	
	if !has_upgrades:
		current_upgrades[upgrade.id]={
			"resource"=upgrade,    
			"quantity"=1
		}
	else:
		current_upgrades[upgrade.id]["quantity"]+=1            #能力有则＋1，无则添加
	Gameevent.emit_ability_upgrade_added(upgrade,current_upgrades)
	
	#print(current_upgrades)
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)
