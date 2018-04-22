extends StaticBody2D

var template = preload("res://Kamikaze.tscn")
var kamikaze

func _ready():
	reload()

func _process(delta):
	if not kamikaze:
		reload()

func reload():
	kamikaze = template.instance()
	get_parent().get_parent().add_child(kamikaze)
	kamikaze.set_global_position(global_position)
	print(kamikaze.global_position)