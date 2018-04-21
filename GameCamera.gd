extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player;
func _ready():
	player = get_node("../Player");
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	position = player.position;
	
	#Rotation Code
#	var angdiff = player.rotation - rotation;
#	if (abs(angdiff) > 180):
#		angdiff = -angdiff
#	rotation += angdiff/20;
#	rotation += sign(angdiff)*min(abs(angdiff), 0.1)
	pass
