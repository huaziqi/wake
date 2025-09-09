# Edit file: res://scripts/enemy/enemy_generator.gd
extends Node
class_name EnemyGenerator

@export var player: Player
@export var master: Master
@export var csv_path := "res://scripts/enemy/enemy_generate_csv/stage_0.csv"
var enemy_num_list : Dictionary = {}
var scene_list : Dictionary = {}

## 当前波次
var _current_wave := 0
## 当前波所有行的配置
var _wave_data: Array[Dictionary] = []
## 当前波所有计时器
var _timers: Array[Timer] = []
## 当前波剩余敌人计数（全部类型合计）
var _total_remaining := 0
## 当前波限时计时器
@export var wave_timer: Timer

## 对外信号：波次结束
signal wave_cleared(wave: int)
signal current_wave_num(wave_num: int)

func _ready() -> void:
	pass

## 供外部调用，进入下一波
func next_wave() -> void:
	stop_current_wave()
	load_next_wave()

## 读取下一波数据
func load_next_wave() -> void:
	_current_wave += 1
	current_wave_num.emit(_current_wave)
	_wave_data.clear()

	var file := FileAccess.open(csv_path, FileAccess.READ)
	if file == null:
		push_error("无法打开 CSV: " + csv_path)
		return
	file.get_line()
	while not file.eof_reached():
		var line := file.get_csv_line()
		print(line)
		if line.is_empty():
			continue
		var wave := int(line[0])
		if wave == _current_wave:
			_wave_data.append({
				enemy = line[1],
				update_time = float(line[2]),
				max_num = int(line[3]),
				max_update_num = int(line[4])
			})

	file.close()

	if _wave_data.is_empty():
		push_warning("没有第 %d 波数据，结束生成" % _current_wave)
		return

	start_current_wave()

## 启动当前波
func start_current_wave() -> void:
	_total_remaining = 0
	_timers.clear()

	# 为每种敌人创建计时器
	for cur_data in _wave_data:
		var enemy_name = cur_data["enemy"]
		var timer := Timer.new()
		timer.wait_time = cur_data["update_time"]
		timer.one_shot = false
		timer.timeout.connect(_on_spawn_timer_timeout.bind(cur_data))
		add_child(timer)
		_timers.append(timer)
		timer.start()

		# 初始化计数
		if not enemy_num_list.has(enemy_name):
			enemy_num_list[enemy_name] = 0
		if not scene_list.has(enemy_name):
			var scene = load("res://scenes/enemy/%s.tscn" % enemy_name)
			if scene:
				scene_list[enemy_name] = scene

		_total_remaining += cur_data["max_num"]

	# 波限时（简单起见：所有 update_time 之和 + 10 秒保底）
	var wave_time := 5
	wave_timer.wait_time = wave_time
	wave_timer.one_shot = true
	wave_timer.timeout.connect(_on_wave_timeout)

	wave_timer.start()

## 停止当前波（清理计时器）
func stop_current_wave() -> void:
	for t in _timers:
		t.queue_free()
	_timers.clear()

## 计时器刷怪
func _on_spawn_timer_timeout(data: Dictionary) -> void:
	var enemy_name : String = data["enemy"]
	var max_num : int = data["max_num"]
	var max_update_num : int = data["max_update_num"]

	if enemy_num_list[enemy_name] >= max_num:
		return

	var spawn_num : int = min(max_num - enemy_num_list[enemy_name], max_update_num)
	for i in spawn_num:
		var enemy = scene_list[enemy_name].instantiate()
		enemy.player = player
		enemy.master = master
		enemy.enemy_die_signal.connect(_on_enemy_die)
		add_child(enemy)
		enemy_num_list[enemy_name] += 1

## 敌人死亡回调
func _on_enemy_die(enemy_name: String) -> void:
	enemy_num_list[enemy_name] -= 1

## 波次超时
func _on_wave_timeout() -> void:
	_end_wave()
	
## 结束当前波
func _end_wave() -> void:
	stop_current_wave()
	wave_cleared.emit(_current_wave)
