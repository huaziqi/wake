extends CanvasLayer

@export var dna_manager:Node
@onready var progeress_bar=$MarginContainer/ProgressBar

func _ready():
	progeress_bar.value=0
	dna_manager.dna_updated.connect(_on_dna_updated)
	
func _on_dna_updated(current_dna:float,target_dna:float):
	var percent_v=(current_dna/target_dna)
	progeress_bar.value=percent_v 
	
