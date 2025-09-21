extends CharacterBody2D
class_name Player

@onready var money_label: Label = $CardUI/Control/MoneyControl/TextureRect/Label
@onready var scan_enemy: Area2D = $graphics/scan_enemy
@onready var graphics: Node2D = $graphics
@onready var collision_2d: CollisionShape2D = $CollisionShape2D
@onready var attackways=$AttackManager#cyy（test）
@export var health_bar: TextureProgressBar
@export var eased_bar: TextureProgressBar
@export var next_wave : Control

const ACCELERATION := 9000
const MAXSPEED := 500
var MAX_HEALTH : float = 100

var direction : Vector2 = Vector2.DOWN
var last_direction : Vector2 = Vector2.DOWN #记录最后一次的位置
var facing_direction : int = 1 # 1表示右边，-1表示左边
var push_force := 50.0 #推力
var current_health : float
var current_max_health : float
signal player_die
var suck_blood : float = 0

var money : int = 0

func _ready() -> void:
	add_to_group("player")
	current_max_health = MAX_HEALTH
	current_health = current_max_health
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	z_index = 199 # 保证显示在大部分图片上方
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#连接升级系统（cyy）

func player_sucks():
	current_health = min(current_max_health, current_health + current_max_health * suck_blood)
	health_update()

func level_up(current_level : int):
	money += 1
	money_label.text = str(money)

func health_update() -> void: #
	var percent = 1.0 * current_health / current_max_health
	health_bar.value = percent
	create_tween().tween_property(eased_bar, "value", percent, 0.2)
	if(current_health == 0):
		player_die.emit()
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):#升级系统初始化武器(cyy)
	for i in attackways.weapon_array.size():
		if upgrade.id==attackways.get_scene_name(attackways.weapon_array[i]) and current_upgrades[upgrade.id]["quantity"]>=1:
			attackways.add_weapon_by_index(i)

	if upgrade.id=="health_bar":#连接升级系统		
		var precent_reduction_health=current_upgrades["health_bar"]["quantity"]
		current_max_health=current_max_health*(1+0.3*precent_reduction_health)
	elif(upgrade.id == "vavampiric_ability"):
		var num=current_upgrades["vavampiric_ability"]["quantity"]
		suck_blood += 0.05 * num
