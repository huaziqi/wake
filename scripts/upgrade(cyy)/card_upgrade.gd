extends PanelContainer

@onready var name_label:Label=$MarginContainer/VBoxContainer/PanelContainer/name
@onready var description_label:Label=$MarginContainer/VBoxContainer/description
@onready var sfx_selected: AudioStreamPlayer = $sfx_selected


signal selected

func _ready():
	gui_input.connect(_on_gui_input)              #guiinput是自带的信号，表示收到Inputevent对应的影响

func play_in(delay:float=0):
	modulate=Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate=Color.WHITE
	$AnimationPlayer.play("出现")
	

func set_ability_upgrade(upgrade:AbilityUpgrade):
	name_label.text=upgrade.name
	description_label.text=upgrade.description


func _on_gui_input(event: InputEvent) :	      #收到左键的影响，发出selected信号，然后在upgrade_screen里再转化成升级的信号                                 
	if event.is_action_pressed("left_click"):     #注意卡牌（也就是这个场景）是upgrade_screen的子节点，但是是在游戏过程中被添加到card_container的
		selected.emit()
		sfx_selected.play()
