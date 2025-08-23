extends Node2D

signal dna_collected(number:float)#全局变量，我对这个的理解就是全局生效

	
func emit_dna_collected(number:float):#主打一个碰撞后被拣去，在colliision里第5个是捡dna
	dna_collected.emit(number)
