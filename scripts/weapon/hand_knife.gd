extends StaticBody2D
class_name HandKnife

var player : Player
var animation_index = -1
@onready var hitbox: Area2D = $hitbox
@export var animation_player : AnimationPlayer
@onready var attack_0_timer: Timer = $Attack_0_timer
@export var attack_0_audio : AudioStream
@export var attack_1_audio : AudioStream

func init_scene(_player : Player, _graphics : Node2D):
	player = _player
	_graphics.add_child.call_deferred(self)
	position.y += 25
	self.visible = false

func _ready() -> void:
	attack_0_timer.timeout.connect(func():
		animation_index = -1
	)

func _physics_process(delta: float) -> void:
	if(player.scan_enemy.enemy_num > 0 and not animation_player.is_playing()):
		if(animation_index == -1 or animation_index == 1):
			animation_player.play("attack_0")
			MusicManager.play_sfx(attack_0_audio)
			animation_index = 0
		elif(animation_index == 0):
			animation_player.play("attack_1")
			MusicManager.play_sfx(attack_1_audio)
			animation_index = 1
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "attack_0"):
		attack_0_timer.start()
