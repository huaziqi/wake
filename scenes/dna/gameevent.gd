extends Node2D

signal dna_collected(number:float)

	
func emit_dna_collected(number:float):
	dna_collected.emit(number)
