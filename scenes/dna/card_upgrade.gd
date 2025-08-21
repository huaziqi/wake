extends PanelContainer

@onready var name_label:Label=$VBoxContainer/name
@onready var description_label:Label=$VBoxContainer/description

signal selected

func _ready():
	gui_input.connect(_on_gui_input)

func set_ability_upgrade(upgrade:AbilityUpgrade):
	name_label.text=upgrade.name
	description_label.text=upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()
