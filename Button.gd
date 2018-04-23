extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_entered",get_node("/root").get_child(0).find_node("Door"),"button_body_entered")
	connect("body_exited",get_node("/root").get_child(0).find_node("Door"),"button_body_exited")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
