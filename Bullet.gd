extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const standable = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _integrate_forces(state):
	for i in range(0, state.get_contact_count()):
		if (state.get_contact_collider_object(i).get_collision_layer_bit(0)):
			queue_free()