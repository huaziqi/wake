extends Node2D
@export var frog_scene:PackedScene
@export var shadow_scene:PackedScene
@export var kills:int 
@export var kills_label:Label
func _process(delta: float) -> void:
	kills_label.text="Frog Kills:"+str(kills)
func _ready() -> void:
	prepare_player()
	kills = 0
func add_kills()	:
	kills_label.bounce()
	await get_tree().create_timer(0.1).timeout
	kills+=1
func spawn_frog():
	var frog=frog_scene.instantiate()
	var shadow=shadow_scene.instantiate()
	frog.position=Vector2(randf_range(-526,526),-350)
	get_tree().current_scene.add_child(frog)
	frog.add_child(shadow)

func prepare_player():
	var player=get_node("Steel_Pipe")
	var shadow=shadow_scene.instantiate()
	player.add_child(shadow)
	


func _on_timer_timeout() -> void:
	spawn_frog()
