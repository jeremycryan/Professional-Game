extends RigidBody2D

export (float) var omega = 1000
export (float) var v = 2000
export (float) var vmax = 100
export (float) var sightRange = 2000
var player
var triggered = false
var angle = 0

func _ready():
	player = get_node("/root").get_child(0).find_node("Player")
	#player = get_node("/root/Node2D/Player")
	#player = find_node("Player")

func _process(delta):
	for body in get_colliding_bodies():
		if not body.get_parent().name == "Spawner":
			if get_parent().get_parent() is StaticBody2D:
				if not triggered:
					if get_parent().get_parent() is StaticBody2D:
						get_parent().get_parent().launch()
			queue_free()
	#print(get_parent().get_parent())
		# TODO: Death animation/explosion
	if player:
		var theta = get_angle_to(player.global_position)+PI/2
		var dist = (player.global_position - global_position).length()
		if triggered:
			apply_impulse(Vector2(), Vector2(0,v*delta).rotated(angle))
		elif sin(theta)>5*PI/180:
			set_applied_torque(-omega)
		elif sin(theta)<-5*PI/180:
			set_applied_torque(omega)
		else:
			set_applied_torque(0)
			if raycast() and dist < sightRange and cos(theta)<0:
				triggered = true
				if get_parent().get_parent() is StaticBody2D:
					get_parent().get_parent().launch()
				angle = global_rotation
				angular_damp = 100

func raycast():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, player.global_position, [self])
	return(result["collider"] is RigidBody2D)
	
func _integrate_forces(state):
	if state.linear_velocity.length() > vmax:
		state.linear_velocity = state.linear_velocity.normalized()*vmax