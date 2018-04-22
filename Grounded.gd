extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var rays;
var grounded = true;

func _ready():
	rays = get_children();
	set_process(true);
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	grounded = false;
	for ray in rays:
		ray.force_raycast_update()
		if (ray.is_colliding()):
			grounded = true;
			break
			
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
