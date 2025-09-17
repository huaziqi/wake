extends Node2D

@onready var next_wave_controller : NextWaveController = $Player.next_wave
@export var enemy_controller : EnemyGenerator
@export var background_music : AudioStream

func _ready() -> void:
	next_wave_controller.next_wave_start.connect(enemy_controller.next_wave)
	enemy_controller.current_wave_num.connect(next_wave_controller.current_wave_show)
	enemy_controller.wave_cleared.connect(next_wave_controller.current_wave_stop)
	MusicManager.play_music(background_music)

func _physics_process(delta: float) -> void:
	next_wave_controller.rest_time.text = str(round(enemy_controller.wave_timer.time_left * 10) / 10)
