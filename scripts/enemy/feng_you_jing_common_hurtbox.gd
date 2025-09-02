extends "res://scripts/enemy/enemy_hurtbox.gd"

@export var hurt_audio : AudioStream
@onready var graphics: Node2D = $".."
@export var animation_player : AnimationPlayer

func hurt_event(area: Area2D) -> void:
	MusicManager.play_sfx(hurt_audio)
	
	if(not animation_player.is_playing()):
		animation_player.play("hurt")
