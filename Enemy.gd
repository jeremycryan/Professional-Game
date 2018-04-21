extends RigidBody2D

export (float) var omega = 300
var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("/root/Node2D/Player")
	pass

func _process(delta):
	if player:
		var theta = sin(get_angle_to(player.global_position)+PI/2)
		if theta>5*PI/180:
			set_applied_torque(-omega)
		elif theta<-5*PI/180:
			set_applied_torque(omega)
		else:
			set_applied_torque(0)