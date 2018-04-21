extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const checkdist = 1000;
const pullstrength = 2000;
const pullmultiplier = 50;
const newPointReqDist = 10;
const unWrapReqDist = 10;
const shootSpeed = 2000;

var grapplePiece = preload("res://Hook.tscn")
var grandparent;
var parent;
var hookInstance = null;
var ropeLen = 99999;
var wrapList = [];
var playerNode;
var grapplephys = null;
var shootStrength;
var shootdir = Vector2();


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	grandparent = get_node("../..");
	parent = get_node("..");
	
	set_process(true)
	pass
	
#func _draw():
#	if (hookInstance != null):
#		var color = Color(1.0, 0.0, 0.0)
#		draw_line(global_position, hookInstance.global_position, color, 20);
#	pass
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var space_state = get_world_2d().get_direct_space_state()
	#if (hookInstance == null and (Input.is_action_just_pressed("shoot_up") or Input.is_action_just_pressed("shoot_down") or Input.is_action_just_pressed("shoot_left") or Input.is_action_just_pressed("shoot_right") ) ): # Input.is_action_just_pressed("grappleShoot")): #(Input.is_action_just_pressed("ropeShoot") or Input.is_action_just_pressed("grappleShoot")):
	if (Input.is_action_just_pressed("grappleShoot")):
#		shootdir = Vector2();
#		if(Input.is_action_just_pressed("shoot_up")):
#			shootdir.y -= 1;
#		if(Input.is_action_just_pressed("shoot_down")):
#			shootdir.y += 1;
#		if(Input.is_action_just_pressed("shoot_left")):
#			shootdir.x -= 1;
#		if(Input.is_action_just_pressed("shoot_right")):
#			shootdir.x += 1;
		grapplephys = true;
#		else:
#			grapplephys = false;
		#var space_state = get_world_2d().get_direct_space_state()
		# OPTION: Mouse-based
		var mouse_pos_diff = (get_global_mouse_position() - global_position);
		var shootdir = mouse_pos_diff.normalized();

		# OPTION: Key-Based
		shootdir = shootdir.normalized()
		
		
		hookInstance = grapplePiece.instance();
		grandparent.add_child(hookInstance);
		hookInstance.set_global_position(global_position);
		hookInstance.linear_velocity = parent.linear_velocity;
		wrapList.append(hookInstance.global_position);
		
		shootStrength = shootSpeed * hookInstance.mass
		
		print(shootSpeed*shootdir)
		hookInstance.apply_impulse(Vector2(), shootSpeed*shootdir)
		parent.apply_impulse(Vector2(), -shootStrength*shootdir / parent.mass)
		
	if (Input.is_action_just_released("grappleShoot")):#!(Input.is_action_pressed("shoot_down") or Input.is_action_pressed("shoot_up") or Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_right"))):#Input.is_action_just_released("ropeShoot") or Input.is_action_just_released("grappleShoot")):
		if (hookInstance != null):
			hookInstance.queue_free()
			hookInstance = null;
			ropeLen = 99999;
			grapplephys = null;
			wrapList.clear();
		
	if (hookInstance != null):
		#Rope Length is set in the Hook
		if (hookInstance.justsecured):
		#var result = space_state.intersect_ray(global_position, global_position + mouse_check_dir, [self]);
		#if (result.empty() == false):
			#hookInstance = grapplePiece.instance();
			print("ropelen ran")
			ropeLen = (global_position - hookInstance.global_position).length() + .5;
			#hookInstance.set_global_position(result.position);
			#grandparent.add_child(hookInstance);
		if (!hookInstance.secured):
			wrapList[0] = hookInstance.global_position;
	
	
	
	# OPTION: Wrapping
	if (wrapList.size() > 0):
		var checkWrap = space_state.intersect_ray(global_position, wrapList.back(), [self], hookInstance.collision_mask)
		if (checkWrap.empty() == false and (checkWrap.position - wrapList.back()).length() > newPointReqDist):
			wrapList.append(checkWrap.position);
		elif (wrapList.size() > 1):
			var checkUnwrap = space_state.intersect_ray(global_position, wrapList[wrapList.size()-2], [self], hookInstance.collision_mask)
			if (checkUnwrap.empty() == true or (checkUnwrap.position - wrapList[wrapList.size()-2]).length() < unWrapReqDist):
				wrapList.pop_back();
			
	
	
	
#	update()
	pass
