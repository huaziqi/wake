extends shoot_weapon_manager
#@onready var hurricane_gap_timer: Timer = $ShootGapTimer
#var hurricane_gap_time=shoot_gap_time

const HURRICANE_DESCRIPTIONS = {
	1: "一级大狂风：召唤微弱的气流阻挡敌人。",
	2: "二级大狂风：风力增强，附带微弱推开效果。",
	3: "三级大狂风：形成小型龙卷风。",
	4: "四级大狂风：伤害范围大幅扩大。",
	5: "五级大狂风：风刃开始具有撕裂效果。",
	6: "6级大狂风：解锁终极风暴特效！",
	7: "7级大狂风：吞噬视线内的一切物品。",
	8: "8级大狂风：神级天灾，寸草不生。"
}

func _ready() -> void:
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统
	shoot_gap_timer.wait_time = shoot_gap_time
	shoot_gap_timer.start()


	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="hurricane":#连接升级系统
		return	
	var hurricane_level=current_upgrades["hurricane"]["quantity"]
	shoot_gap_timer.wait_time=shoot_gap_time*0.8**(hurricane_level)
	print(shoot_gap_time)
	print(shoot_gap_timer.wait_time)
	print("风")
	upgrade.description = HURRICANE_DESCRIPTIONS[hurricane_level]
	print("changed")

	
	if upgrade.id=="shoot_weapon_manager":    
		var precent_reduction=current_upgrades["shoot_weapon_manager"]["quantity"]
		shoot_gap_time=shoot_gap_time*(1-0.05*precent_reduction)
		shoot_gap_timer.wait_time=(shoot_gap_timer.wait_time)*0.95
		print("全体射击武器基础速度加5%",shoot_gap_time)
		print(shoot_gap_timer.wait_time)
	# 同样，复制一份资源用于UI显示
		# 根据等级从字典里抓取对应的描述，如果找不到就用默认文本
		
	
	else:
		return
	
