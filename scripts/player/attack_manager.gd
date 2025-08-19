extends Node

@onready var graphics: Node2D = $"../graphics"
@onready var player: Player = $".."
@export var scan_enemy: Area2D

const SHOOT_WEAPON = preload("res://scenes/weapon/shoot_weapon.tscn")
const ROTATE_WEAPON = preload("res://scenes/weapon/rotate_weapon.tscn")
const Hand_Knife = preload("res://scenes/weapon/hand_knife.tscn")

var shootTimer : Timer
var rotate_weapon : Rotate_Weapon
var hand_knife : HandKnife

func _ready() -> void:
	shootTimer = Timer.new() #定时发射
	add_child(shootTimer)
	shootTimer.wait_time = 1 #间隔时间为0
	shootTimer.start()
	shootTimer.one_shot = false
	shootTimer.timeout.connect(on_timer_timeout.bind("shoot_timer"))
	
	#rotate_weapon = ROTATE_WEAPON.instantiate()
	#rotate_weapon.player = player
	#get_tree().current_scene.add_child.call_deferred(rotate_weapon)
	
	hand_knife = Hand_Knife.instantiate()
	hand_knife.player = player
	hand_knife.position = player.position
	graphics.add_child.call_deferred(hand_knife)
	hand_knife.visible = false

func _physics_process(delta: float) -> void:
	if(not hand_knife.animation_player.is_playing()):
		if(scan_enemy.enemy_num > 0):
			hand_knife.animation_player.play("attack_0")

func on_timer_timeout(timerName : String):
	timerName = timerName.to_lower()
	if(timerName == "shoot_timer"):
		var SHOOT_WEAPON = SHOOT_WEAPON.instantiate()
		SHOOT_WEAPON.player = player
		SHOOT_WEAPON.position = player.position
		print(player.position)
		SHOOT_WEAPON.set_direction(player.last_direction)
		get_tree().current_scene.add_child.call_deferred(SHOOT_WEAPON)
