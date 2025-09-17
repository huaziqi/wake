extends Node2D
# 旋转速度

@onready var unable: Sprite2D = $graphics/PlantGraphics/unable
@onready var able: Sprite2D = $graphics/PlantGraphics/able
@export var rotation_speed = 360
@export var plant_area_rect : ColorRect
var plant_area_shader : ShaderMaterial
var targets = []
var rotation_angle

var tower_num : int = 0
var in_able : bool = false #在可种植区内
var in_forbid : bool = false #超出了一些范围
var planted : bool = false # 是否被种植下去了
var plantable : bool = false # 是否可以种植

signal planted_signal

func _ready() -> void:
	plant_area_shader = plant_area_rect.material

func _physics_process(delta: float) -> void:
	if(planted == false):
		global_position = get_global_mouse_position()
		plantable = in_able and (not in_forbid) and (tower_num == 0)
		if(plantable):
			plant_area_shader.set_shader_parameter("circle_color", Color(1, 1, 1, 0.45))
			if(Input.is_action_just_pressed("left_click")):
				place()
		else:
			#able.visible = false
			#unable.visible = true
			plant_area_shader.set_shader_parameter("circle_color", Color(1, 0, 0, 0.45))
		if(Input.is_action_just_pressed("right_click")):
			queue_free()
	else:
		if targets.size()!=0:
			var target_position = find_closest_enemy().global_position
			var direction = target_position - global_position
			rotation_angle = direction.angle()
			rotation = rotation_angle
		
func find_closest_enemy():
	var closest_enemy = null
	var closest_distance = -1
	for target in targets:
		var distance = (target.global_position - global_position).length()
		if closest_distance == -1 or distance < closest_distance:
			closest_distance = distance
			closest_enemy = target
	return closest_enemy

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		targets.append(body)

func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		targets.erase(body)

func _on_plant_area_area_entered(area: Area2D) -> void:
	in_able = in_able if not (area.collision_layer & (1 << 6)) else true
	in_forbid = in_forbid if not (area.collision_layer & (1 << 7)) else true
	tower_num = tower_num if not (area.collision_layer & (1 << 8)) else tower_num + 1

	#print("in_able: ", in_able, ", in_forbid: ", in_forbid, ", in_tower: ", in_tower)


func _on_plant_area_area_exited(area: Area2D) -> void:
	#if(area.collision_layer & (1 << 6)):
		#in_able = false
	#if(area.collision_layer & (1 << 7)):
		#in_forbid = false
	#if(area.collision_layer & (1 << 8)):
		#in_tower = false
	in_able = in_able if not (area.collision_layer & (1 << 6)) else false
	in_forbid = in_forbid if not (area.collision_layer & (1 << 7)) else false
	tower_num = tower_num if not (area.collision_layer & (1 << 8)) else tower_num - 1

	#print("in_able: ", in_able, ", in_forbid: ", in_forbid, ", in_tower: ", in_tower)

func place() -> void: #放置函数
	planted = true
	able.visible = false
	planted_signal.emit()