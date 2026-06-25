extends StaticBody2D
class_name Rotate_Weapon

var rotation_angle : float = 0.0
var rotation_speed: float = 80.0   #公转速度
var orbit_radius: float = 90   #半径大小
var player: Player

var weapon_num : int = 1  #武器数量
var base_damage : int = 50
var current_damage : int
var weapon_array : Array = []

const ROTATE_WEAPON_DESCRIPTIONS = {
	1: "1级别螺旋桨：增加数量和速度",
	2: "2级别螺旋桨：增加数量和速度",
	3: "3级别螺旋桨：增加数量和速度",
	4: "4级别螺旋桨：变成奶龙螺旋",
	5: "5级别螺旋桨：风力增强，附带微弱推开效果。",
	6: "6级别螺旋桨：风力增强，附带微弱推开效果。",
	7: "7级别螺旋桨：风力增强，附带微弱推开效果。",
	8: "8级别螺旋桨：风力增强，附带微弱推开效果。"
}

@onready var graphics: Node2D = $graphics

func init_scene(_player : Player, _graphics : Node2D):
	player = _player
	_graphics.add_child.call_deferred(self)

func _ready():
	Gameevent.ability_upgrade_added.connect(on_ability_upgrade_added)#升级系统的测试(cyy)
	add_to_group("weapon")
	current_damage = base_damage
	copy_weapon()

func _physics_process(delta: float) -> void:
	control_weapon(delta)
	pass
	#print("player position: ", player.position, "rotate_weapon_position: ", position)

func copy_weapon():
	weapon_array.append(graphics)
	for i in (weapon_num - 1):
		var copyed_weapon = graphics.duplicate()
		copyed_weapon.position = Vector2.ZERO
		copyed_weapon.name = "weapon_%d" % (i + 1)
		weapon_array.append(copyed_weapon)
		add_child(copyed_weapon)

func control_weapon(delta : float):
	var gap_angle = 2 * PI / weapon_num as float
	var angle = deg_to_rad(rotation_angle)
	for i in weapon_array.size():
		angle += gap_angle
		var offset = Vector2(cos(angle), sin(angle)) * orbit_radius
		weapon_array[i].position = player.graphics.position + offset
	rotation_angle += rotation_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("enter")
	pass

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	var rotate_level=current_upgrades["rotate_weapon"]["quantity"]
	if upgrade.id!="rotate_weapon":#连接升级系统
		return
	#if current_upgrades["rotate_weapon"]["quantity"]==2:
		
	var precent_reduction=current_upgrades["rotate_weapon"]["quantity"]
	#改数值
	rotation_speed=rotation_speed*1.2#*(precent_reduction)
	weapon_num+=1
	copy_weapon()
	print("螺旋桨速度增加0.2，并且增加数量")
	print(rotation_speed)
	print(weapon_num)
	upgrade.description = ROTATE_WEAPON_DESCRIPTIONS[rotate_level]
	
