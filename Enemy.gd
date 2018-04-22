extends RigidBody2D

export (float) var omega = 5000
export (float) var v = 3000
export (float) var sightRange = 2000
var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("/root/Node2D/Player")
	pass

func _process(delta):
	if player:
		var theta = get_angle_to(player.global_position)+PI/2
		var dist = (player.global_position - transform.origin).length()
		if sin(theta)>5*PI/180:
			set_applied_torque(-omega)
		elif sin(theta)<-5*PI/180:
			set_applied_torque(omega)
		else:
			set_applied_torque(0)
			if dist < sightRange:
				apply_impulse(Vector2(), Vector2(0,v*delta).rotated(global_rotation))