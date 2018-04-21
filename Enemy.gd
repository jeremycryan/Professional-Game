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
		var dx = player.position - position
		set_applied_torque(omega)
		print(dx)

