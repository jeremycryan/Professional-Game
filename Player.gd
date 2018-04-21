extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var new_impulse = Vector2(0.0,1.0);
#var local_col_pos = Vector2(0.0,0.0);
const walkspd = 5000; #3000
const driftspd = 100;
const jumpspd = 60000; #40000
const jumpMult = 60000/5000; #40000/3000
const jumpTime = 1;
const termvel = 1000; #600
const maxDriftSpd = 0; #if set to a value gives ability to drift in the air
const no_move_damp = 15;
const wallCheckDist = 33;
const minDriftSpd = 0; #if set to a value gives min linearvelocity
const playerCollisionSize = 25;

var moving = true;
var onWall = false;
var counter = 0;
var jumpTimer = -1;
var movdir = Vector2(0, -1);
#var grappleController;
#var move = Vector2(0.0,0.0);

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#grappleController = get_node("GrappleController")
	set_process(true);
	set_physics_process(true);
	pass

func _physics_process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var move = Vector2(0.0,0.0);
	moving = false;
	# OPTION: Only allow movement on walls.
#	if (onWall):
#		if (Input.is_action_pressed("mv_right")):
#			move.x += 1;
#			moving = true;
#		if (Input.is_action_pressed("mv_left")):
#			move.x -= 1;
#			moving = true;
#		if (Input.is_action_pressed("mv_up")):
#			move.y -= 1;
#			moving = true;
#		if (Input.is_action_pressed("mv_down")):
#			move.y += 1;
#			moving = true;
#		move = move.normalized(); #At this point, move is a unit vector
			
	# OPTION: Allow Drifting in the air if linear velocity is less than a certain amount
	if (onWall or linear_velocity.length() < maxDriftSpd):
		if (Input.is_action_pressed("mv_right")):
			move.x += 1;
			moving = true;
		if (Input.is_action_pressed("mv_left")):
			move.x -= 1;
			moving = true;
		if (Input.is_action_pressed("mv_up")):
			move.y -= 1;
			moving = true;
		if (Input.is_action_pressed("mv_down")):
			move.y += 1;
			moving = true;
		move = move.normalized(); #At this point, move is a unit vector
		if (onWall):
			var tmpmove = move.slide(movdir) * walkspd #THIS MAKES MOVEMENT ONLY ON WALL BUT DOESNT INCLUDE JUMP. (otherwise you wouldn't be able to jump)
			# OPTION: Jump with space
#			if (Input.is_action_pressed("jump") && jumpTimer > jumpTime):
#				print("jump %d" % counter)
#				onWall = false;
#				print(movdir)
#				tmpmove += movdir * jumpspd;
#				counter += 1;
#				jumpTimer = -1;
#				moving = true;
#			else:
#				jumpTimer += 1;
			# OPTION: Jump with Perpendicular button
			var proj = movdir.dot(move);
			if (proj > 0 && jumpTimer > jumpTime):
				tmpmove += movdir * (jumpspd - walkspd) #OPTION: (* proj) This would make jump smaller when moving and faster when no other arrow keys are pressed #Jump based on the amount of perpendicular movement

				onWall = false;
				jumpTimer = -1;
				moving = true;
			else:
				jumpTimer += 1;
			move = tmpmove #At this point,  move is in actual values to be used for impulse
		else:
			move = move * driftspd;
		
		
		
		
		
		
		
		
	"""	
	var grap_pull = Vector2();
	if (grappleController.wrapList.size() != 0 and grappleController.hookInstance != null and grappleController.hookInstance.secured):
		var grap_point = grappleController.wrapList.back();
		var grap_diff = grap_point - global_position;
		var grap_dir = grap_diff.normalized();
		var grap_dist = grap_diff.length();
		for i in range(1, grappleController.wrapList.size()):
			grap_dist += (grappleController.wrapList[i] - grappleController.wrapList[i-1]).length();
		
		
		if (grappleController.grapplephys):
			# OPTION: Grappling Hook that Pulls
			var pullstrength = grappleController.pullstrength;
			var proj = movdir.dot(grap_dir);
			if (proj > 0): #Check that the grapple would pull you off the wall
				moving = true;
				
				onWall = false;
			
			if (grap_dist > grappleController.ropeLen):
				pullstrength += (grap_dist - grappleController.ropeLen) * grappleController.pullmultiplier;
			else:
				grappleController.ropeLen = grap_dist;
			grap_pull = grap_dir * pullstrength;
			
#		else:
#			# OPTION: Grappling Rope
#			if (grap_dist > grappleController.ropeLen):
#				var proj = movdir.dot(grap_dir);
#				if (proj > 0): #Check that the grapple would pull you off the wall
#					moving = true;
#					onWall = false;
#				#Calculate Rope Tension Force
#				var velToCorrect = linear_velocity.dot(-grap_dir)/2; #The length of grap_dir is 1, therefore this is a projection of the linear_velocity into the grap_dir direction, and is the length
#				var offset_pull = max(grap_dist - grappleController.ropeLen - 1, 0) * 3 ; #This value allows for normal pulling in a certain range, and then increased pulling if player gets too far away from grapple point
#	#			if (offset_pull > 0):
#	#				print("o_dist: ", grap_dist - grappleController.ropeLen , "| o_pull: ", offset_pull);
#				if (velToCorrect + offset_pull > 0):
#					grap_pull = (grap_dir * (velToCorrect + offset_pull) * mass)/delta;
#
#			# OPTION: Passive Reeling
#			else:
#				grappleController.ropeLen = grap_dist;
	
	# TODO: Maybe make jumps shorter if moving faster?
	"""
	new_impulse = (move) * delta;
	#var imp_proj_vel = new_impulse.normalized().dot(rotate_vec(linear_velocity.normalized(), -global_rotation)); #Everything in local frame
	var imp_proj_vel = new_impulse.normalized().dot(linear_velocity.normalized()); # Everything in Global frame
	var extraimp = -imp_proj_vel * new_impulse * (linear_velocity.length()/termvel);
	new_impulse += extraimp;
	
	#apply_impulse(Vector2(), rotate_vec(new_impulse, global_rotation));
	apply_impulse(Vector2(), new_impulse);

func rotate_vec(vec, rot):
	var i = vec.x*cos(rot) - sin(rot) * vec.y;
	var j = vec.x*sin(rot) + cos(rot) * vec.y;
	return Vector2(i,j);

#func rotate_to_global(vec, rot):
#	var i = vec.x*cos(rot) + sin(rot) * vec.y;
#	var j = -vec.x*sin(rot) + cos(rot) * vec.y;
#	return Vector2(i,j);

func _integrate_forces(state):
	var form = state.transform;
	var space_state = get_world_2d().get_direct_space_state()
	
	
	
	#if (state.get_contact_count() >= 1):
	for i in range(0, state.get_contact_count()):
		if (state.get_contact_collider_object(i).get_collision_layer_bit(4)):
				RestartLevel()
#		onWall = true;
#		var col_pos = state.get_contact_local_normal(0);
#		#print(form)
#		var rot = form.get_rotation()
#
#		# Do I need this since I do it later?
#		var ang = Vector2(0, -1).angle_to(col_pos)
#		form.x = rotate_vec(Vector2(1, 0), ang);
#		form.y = rotate_vec(Vector2(0, 1), ang);
#		form.origin += col_pos; # put the character a bit off of the wall to prevent constant collisions
#		#linear_velocity = linear_velocity.slide(col_pos)
#	else:
		#Check the four cardinal directions for walls
#	var result = space_state.intersect_ray(global_position, global_position + form.y*wallCheckDist, [self])
#	if (result.empty() == false):
#		checkForWall(form, result)
#	else:
#		var res2 = space_state.intersect_ray(global_position, global_position - form.y*wallCheckDist, [self])
#		if	(res2.empty() == false):
#			checkForWall(form, res2)
#		else:
#			var res3 = space_state.intersect_ray(global_position, global_position + form.x*wallCheckDist, [self])
#			if(res3.empty() == false):
#				checkForWall(form, res3)
#			else:
#				var res4 = space_state.intersect_ray(global_position, global_position - form.x*wallCheckDist, [self])
#				if(res4.empty() == false):
#					checkForWall(form, res4)
		
		#print(form)
		#rotate(-PI/2)
	
	if (onWall):
		
		#Turn this 
		var result = space_state.intersect_ray(global_position, global_position + form.y*wallCheckDist, [self], collision_mask)
		
		if (result.empty() == true or !result.collider.standable):
			onWall = false;
			jumpTimer = -1;
		else:
			var ang = Vector2(0, -1).angle_to(result.normal)
			form.x = rotate_vec(Vector2(1, 0), ang);
			form.y = rotate_vec(Vector2(0, 1), ang);
			movdir = result.normal #rotate_vec(result.normal,PI/2);
		
		#physics properties based on wall
		if(onWall):
			state.linear_velocity = state.linear_velocity.slide(movdir)
			#state.linear_velocity = state.linear_velocity.clamped(termvel)
	else:
		var result = space_state.intersect_ray(global_position, global_position + form.y*wallCheckDist, [self], collision_mask)
		if (result.empty() == false):
			form = checkForWall(form, result)
		else:
			var res2 = space_state.intersect_ray(global_position, global_position - form.y*wallCheckDist, [self], collision_mask)
			#print("test1")
			if	(res2.empty() == false):
				#print("test2")
				form = checkForWall(form, res2)
			else:
				var res3 = space_state.intersect_ray(global_position, global_position + form.x*wallCheckDist, [self], collision_mask)
				if(res3.empty() == false):
					form = checkForWall(form, res3)
				else:
					var res4 = space_state.intersect_ray(global_position, global_position - form.x*wallCheckDist, [self], collision_mask)
					if(res4.empty() == false):
						form = checkForWall(form, res4)
					
		state.linear_velocity = max(state.linear_velocity.length(), minDriftSpd) * state.linear_velocity.normalized();
		
	#more physics properties based on wall
	if (onWall and not moving):
		linear_damp = no_move_damp;
	else:
		linear_damp = 0;
	
	state.set_transform(form);



func checkForWall(form, result):
	if (result.collider.standable and result.normal.dot(linear_velocity.normalized()) < .05 and !onWall):
		onWall = true;
		var rot = form.get_rotation()
		
		# Do I need this? since  I do it later?
		var ang = Vector2(0, -1).angle_to(result.normal)
		form.x = rotate_vec(Vector2(1, 0), ang);
		form.y = rotate_vec(Vector2(0, 1), ang);
		movdir = result.normal;
		form.origin = result.position;
		form.origin += result.normal * playerCollisionSize; # put the character a bit off of the wall to prevent constant collisions
		return form;
	return form

func RestartLevel():
	get_tree().reload_current_scene();