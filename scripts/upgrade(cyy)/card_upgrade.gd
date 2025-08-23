extends PanelContainer

@onready var name_label:Label=$VBoxContainer/name
@onready var description_label:Label=$VBoxContainer/description

signal selected

func _ready():
	gui_input.connect(_on_gui_input)              #guiinput是自带的信号，表示收到Inputevent对应的影响


func set_ability_upgrade(upgrade:AbilityUpgrade):
	name_label.text=upgrade.name
	description_label.text=upgrade.description


func _on_gui_input(event: InputEvent) :	      #收到左键的影响，发出selected信号，然后在upgrade_screen里再转化成升级的信号                                 
	if event.is_action_pressed("left_click"):     #注意卡牌（也就是这个场景）是upgrade_screen的子节点，但是是在游戏过程中被添加到card_container的
		selected.emit()
