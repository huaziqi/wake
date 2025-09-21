extends Node2D

@onready var next_wave_controller : NextWaveController = $player.next_wave
@export var enemy_controller : EnemyGenerator
@export var background_music : AudioStream
@onready var master: Master = $master
@onready var player: Player = $player
@onready var enemy_generator: EnemyGenerator = $EnemyGenerator
const MASTER = preload("uid://dlo3n7hvwctoc")
const PLAYER = preload("uid://qi8cxx074bja")
const TEST_SCENE = preload("uid://c1wko1rfba2e7")

func _ready() -> void:
	player.attackways.add_weapon_by_index(1)
	next_wave_controller.next_wave_start.connect(enemy_controller.next_wave)
	enemy_controller.current_wave_num.connect(next_wave_controller.current_wave_show)
	enemy_controller.wave_cleared.connect(next_wave_controller.current_wave_stop)
	MusicManager.play_music(background_music)
	player.player_die.connect(game_over)
	master.master_die.connect(game_over)
	enemy_controller.game_win.connect(game_win)
	enemy_controller.enemy_die.connect(player.player_sucks)

func _physics_process(delta: float) -> void:
	next_wave_controller.rest_time.text = str(round(enemy_controller.wave_timer.time_left * 10) / 10)

func game_over():
	MusicManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/player/game_over.tscn")

func game_win():
	MusicManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/player/game_win.tscn")
