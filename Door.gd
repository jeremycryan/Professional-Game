extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var currentBody

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func button_body_entered(body):
	if(currentBody == null):
		currentBody = body
		set_collision_layer_bit(0,false)
		get_child(1).hide()
	
func button_body_exited(body):	
	if(currentBody == body):
		set_collision_layer_bit(0,true)
		get_child(1).show()
		currentBody = null