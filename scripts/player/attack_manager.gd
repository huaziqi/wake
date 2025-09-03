extends Node

@onready var graphics: Node2D = $"../graphics"
@onready var player: Player = $".."
@export var scan_enemy: Area2D
@export var timers : Node

@export var weapon_array : Array[PackedScene] #存储所有武器
var name_to_index_dic : Dictionary #名字转索引
@export var weapon_property : Dictionary

var weapon_idx : int = 0
var shootTimer : Timer
var rotate_weapon : Rotate_Weapon
var hand_knife : HandKnife

func get_scene_name(scene : PackedScene) -> String:
	return scene.resource_path.get_file().get_basename()

func _ready() -> void:
	#Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统信号(cyy)
	for weapon in weapon_array:
		var weapon_name = get_scene_name(weapon) #武器名字
		name_to_index_dic[weapon_name] = weapon_idx 
		weapon_idx += 1 #武器id进一
		var inited_weapon = weapon.instantiate()
		if(not weapon_property.has(weapon_name)): #如果字典中没有该武器
			weapon_property[weapon_name] = {}
		for key in weapon_property["all_property"]: #遍历所有属性
			if(key in inited_weapon): #如果该武器有这个属性
				weapon_property[weapon_name][key] = weapon_property["all_property"][key]
	
	#print(weapon_property)	
	
	#add_weapon_by_index(0)
	add_weapon_by_index(1)
	#add_weapon_by_index(2)
	#add_weapon_by_index(3)
	#add_weapon_by_index(2)
	#add_weapon_by_index(3)
	#add_weapon_by_index(4)
	
func add_weapon_by_name(name : String) -> void:
	if(name in name_to_index_dic):
		add_weapon_by_index(name_to_index_dic[name])
	else:
		print("不存在", name, "in attack_manager : add_weapon_by_name")

#添加武器 index : 在weapon_array中的索引值
func add_weapon_by_index(index : int) -> void:
	if(index < 0 or index >= weapon_array.size()):
		print(index, "超出了武器数组范围", ": file in attack_manager")
	if(index in weapon_property["in_use"]):
		print(get_scene_name(weapon_array[index]), "已经被添加了", ": file in attack_manager")
		return
	var weapon : Node = weapon_array[index].instantiate()

	if("init_scene" in weapon):
		weapon.init_scene(player, graphics)
		
	
	weapon_property["in_use"].append(index)
	
func time_gap_weapon(weapon_scene : PackedScene,  weapon : Node) -> void:
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = weapon.shoot_gap_time
	timers.add_child(timer)
	timer.timeout.connect(func():
		var new_weapon = weapon_scene.instantiate()
		if("shoot_gap_timer" in new_weapon):
			new_weapon.shoot_gap_timer = timer
		if("init_scene" in new_weapon):
			new_weapon.init_scene(player, graphics)
		get_tree().current_scene.add_child.call_deferred(new_weapon)
	)
	timer.start()

#func _physics_process(delta: float) -> void:
	#if(not hand_knife.animation_player.is_playing()):
		#if(scan_enemy.enemy_num > 0):
			#hand_knife.animation_player.play("attack_0")
			#
