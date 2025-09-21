extends Node

const Music_BUS = "Music"
const SFX_BUS = "SFX"

var music_players_num := 2
var music_players_index := 0
var music_players : Array[AudioStreamPlayer]

var sfx_players_num := 10
var sfx_players : Array[AudioStreamPlayer]

func _ready() -> void:
	init_music_player()
	init_sfx_player()
	
func init_music_player() -> void: #初始化音乐播放器
	for i in music_players_num:
		var music_player : AudioStreamPlayer = AudioStreamPlayer.new()
		music_player.bus = Music_BUS
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS #即使暂停游戏也继续播放
		music_player.finished.connect(_on_music_finished.bind(i))
		add_child(music_player)
		music_players.append(music_player)

func _on_music_finished(player_index : int) -> void:
	# 当音乐播放结束时重新播放
	var player = music_players[player_index]
	if player.stream != null:
		player.play()
		

func play_music(_audio : AudioStream) -> void:
	var current_music_player = music_players[music_players_index]
	if(current_music_player.stream == _audio):
		return
	var next_index = 1 if music_players_index == 0 else 0
	var next_music_player = music_players[next_index]
	current_music_player.stop()
	current_music_player.stream = null
	next_music_player.stream = _audio
	next_music_player.play()
	music_players_index = next_index

func stop_music() -> void:
	# 停止当前正在播放的音乐
	var current_music_player = music_players[music_players_index]
	current_music_player.stop()
	current_music_player.stream = null

func init_sfx_player() -> void: #初始化音效播放器
	for i in sfx_players_num:
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.bus = SFX_BUS
		add_child(sfx_player)
		sfx_players.append(sfx_player)

func play_sfx(_audio : AudioStream) -> void:
	var got_spare := false #判断是否找到了空闲的播放器
	for current_player in sfx_players:
		if(not current_player.playing): #找到了没有在播放的播放器
			current_player.stream = _audio
			current_player.play()
			got_spare = true
			break
	if(not got_spare):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.bus = SFX_BUS
		add_child(sfx_player)
		sfx_players.append(sfx_player)
		
