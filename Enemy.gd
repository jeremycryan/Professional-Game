extends RigidBody2D

export (float) var omega = 300
export (float) var v = 100
export (float) var sightRange = 200
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
			applied_force *= 0.9
		elif sin(theta)<-5*PI/180:
			set_applied_torque(omega)
			applied_force *= 0.9
		else:
			set_applied_torque(0)
			applied_force *= 0.9
			if dist > sightRange:
				add_force(Vector2(), Vector2(v,0).rotated(theta))