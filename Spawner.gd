extends StaticBody2D

export (float) var cooldown = 1

onready var template = preload("res://Kamikaze.tscn")
var t0 = 0
var fired = false

func _ready():
	reload()

func _process(delta):
	if fired and OS.get_ticks_msec()/1000.0>t0:
		reload()
		fired = false

func reload():
	var kamikaze = template.instance()
	add_child(kamikaze)
	kamikaze.set_global_position(global_position)
	
func launch():
	fired = true
	t0 = OS.get_ticks_msec()/1000.0 + cooldown