extends Node

@export var upgrade_pool:Array[AbilityUpgrade]
@export var dna_manager:Node
@export var upgrade_scene:PackedScene


var already_upgrades={} #储存已经升级的相关所有数据

func _ready():
	dna_manager.level_up.connect(on_level_up)
	
func pick_upgrades():
	var total_chosen_upgrades:Array[AbilityUpgrade]=[]#用实现卡牌互不相同
	
	var filtered_upgrades=upgrade_pool.duplicate()
	filtered_upgrades=filtered_upgrades.filter(func(upgrade):
	#最大等级判定
		var upgrade_data = already_upgrades.get(upgrade.id, {})
		var current_qty = upgrade_data.get("quantity", 0)
		if not already_upgrades.has(upgrade.id): #如果从未选过该卡牌
			if current_qty>=upgrade.max_chosen_time:
				return false
		elif already_upgrades.has(upgrade.id): #是否达到最大可选d次数
			if current_qty>=upgrade.max_chosen_time:
				return false
	#判定前提条件
		if not upgrade.prerequisites.is_empty(): 
			for pre_string in upgrade.prerequisites:
				# 1. 拆分字符串。例如把 "storm_1:3" 拆成 ["storm_1", "3"]
				var parts = pre_string.split(":")
				var req_id = parts[0]
				var req_level = 1
				if parts.size() > 1:
					req_level = int(parts[1])
				
				# 2. 检查玩家记事本，看看有没有这个前置武器
				if not already_upgrades.has(req_id):
					return false 
				# 3. 检查是否拥有足够的前置卡牌数量和小于最多选择次数
				var current_qty_player = already_upgrades[req_id]["quantity"]
				if current_qty_player < req_level:
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
	var has_upgrades=already_upgrades.has(upgrade.id)         #获取已经升级的数据对应的id
	
	if !has_upgrades:
		already_upgrades[upgrade.id]={
			"resource"=upgrade,    
			"quantity"=1
		}
		Log.debug("升级系统","该武器未被选过，设置quantity数值为1")
	else:
		already_upgrades[upgrade.id]["quantity"]+=1            #能力有则＋1，无则添加
	Gameevent.emit_ability_upgrade_added(upgrade,already_upgrades)
	
	#print(already_upgrades)
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)
