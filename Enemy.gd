extends RigidBody2D

export (float) var omega = 1000
export (float) var v = 2000
export (float) var vmax = 100
export (float) var sightRange = 2000
export (bool) var aim = true

var player

func _ready():
	player = get_node("/root").get_child(0).find_node("Player")
	
	#player = find_node("Player")

func _process(delta):
	if player:
		var theta = get_angle_to(player.global_position)+PI/2
		var dist = (player.global_position - global_position).length()
		if sin(theta)>5*PI/180:
			set_applied_torque(-omega)
		elif sin(theta)<-5*PI/180:
			set_applied_torque(omega)
		else:
			set_applied_torque(0)
			if aim and raycast() and dist < sightRange and cos(theta)<0:
				apply_impulse(Vector2(), Vector2(0,v*delta).rotated(global_rotation))
		if not aim and raycast() and dist < sightRange and cos(theta)<0:
			apply_impulse(Vector2(), (player.global_position - global_position).normalized()*v)
				
func raycast():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, player.global_position, [self])
	if not result:
		return false
	return(result["collider"] is RigidBody2D)
	
func _integrate_forces(state):
	if state.linear_velocity.length() > vmax:
		state.linear_velocity = state.linear_velocity.normalized()*vmax

func kill():
	for child in get_children(): #Delete the enemy and its children if it has been dashed through
		child.free();
	get_parent().free();