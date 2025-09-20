extends Area2D

@onready var master: Master = $".."
@export var bubbles : Array[Control]
@export var gpu_particles_2d: GPUParticles2D
@export var bomb_area: Area2D
@export var common_bubble: Sprite2D
@export var sprite_2d: Sprite2D
@export var bomb_collision: CollisionShape2D

signal master_die_pre

var last_num : int = 5
var in_bomb : bool = false

func _on_area_entered(area: Area2D) -> void:
	if("real_damage" in area):
		master.current_sleepness = max(master.current_sleepness - area.real_damage, 0)
		sleepness_update()

func sleepness_update() -> void:
	if(master.current_sleepness == 0):
		master_die_pre.emit()
	var sleepness_percent : float = master.current_sleepness / master.max_sleepness
	var bubble_num : int = ceil(sleepness_percent / float(1.0 / 5))
	if(bubble_num != last_num):
		last_num = bubble_num
		bomb()
	for i in range(bubbles.size() - 1, bubble_num - 1, -1):
		bubbles[i].visible = false
	

func _physics_process(delta: float) -> void:
	if(gpu_particles_2d.emitting == false and common_bubble.visible == false):
		common_bubble.visible = true
	if(in_bomb):
		var circle = bomb_collision.shape as CircleShape2D
		circle.radius += delta * 500

func bomb() -> void:
	if(in_bomb):
		return
	in_bomb = true
	sprite_2d.modulate.a = 0.3
	monitorable = false
	monitoring = false
	common_bubble.visible = false
	gpu_particles_2d.emitting = true
	get_tree().create_timer(1, false).timeout.connect(func():
		sprite_2d.modulate.a = 1
		gpu_particles_2d.emitting = false
		monitorable = true
		monitoring = true
		in_bomb = false
		var circle = bomb_collision.shape as CircleShape2D
		circle.radius = 0.01
		bomb_area.visible = false
		)
