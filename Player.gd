extends RigidBody2D

var bulletFab = preload("res://Bullet.tscn");

var parent;
var grandparent;
var bulletRef = null;
var shootSpeed = 500;
var motion = Vector2();
#var new_impulse = Vector2();
var gravity = Vector2(0, 15);
var jumpStrength = -500;
#var speed = 1000;

var airaccel = 1500;
var groundaccel = 4000;
var maxHoriSpeed = 500;

#var termvel_x = 99999; #Terminal Velocity

var jumpClock = 0; #jump timer
var jumpTime = .5; #number of seconds after leaving ground at which you can jump
var jumpDebounceTime = .05;
var jumpDebounceClock = 0;
onready var groundChecker = get_node("Grounded");

#var jumping = 0;
#var canJump = false;
var die = false;
var dashNum = 3;
var dashes = dashNum;
var resolution_factor = 8;
var dashLineTime = 0.5; #Time in seconds the dash lines stay on screen
var dashLines = [];
var bloodSplatTime = 1 #Time in seconds the blood splats stay on screen
var bloodSplats = [];
var bloodSplatRadius = 16;
var camera;

onready var anim = get_node("player_anim");
var cur_anim = "Idle"
var new_anim = "Idle"

func animate(animation):
	var a_sprite = find_node(animation);
	if not anim.is_playing():
		anim.play(animation)
	elif animation == cur_anim:
		return
	else:
		for n in get_node("Sprites").get_children():
			n.hide();
		a_sprite.show();
		anim.play(animation);
		cur_anim = animation

func _process(delta):
	for dash_line in dashLines:
		if dash_line[2] > 0:
			dash_line[2] -= delta;
		else:
			dashLines.pop_front();
			
	for blood_splat in bloodSplats:
		if blood_splat[1] > 0:
			blood_splat[1] -= delta;
		else:
			bloodSplats.pop_front();
			
	update();
	
	if (groundChecker.grounded and jumpDebounceClock > jumpDebounceTime):
		jumpClock = 0;
		dashes = dashNum
	
	motion = Vector2(0,0);
	#jumping = Vector2(0,0);
	var jumping = false;
	var space_state = get_world_2d().get_direct_space_state()
	
	
	jumpClock += delta;
	jumpDebounceClock += delta;
	
	if (Input.is_action_just_pressed("shoot")):
		if (bulletRef != null and bulletRef.get_ref()):
			bulletRef.get_ref().queue_free()
			bulletRef = null
			pass
		
		var mouse_pos_diff = (get_global_mouse_position() - global_position);
		var shootdir = mouse_pos_diff.normalized();
		
		var bulletInst = bulletFab.instance();
		grandparent.add_child(bulletInst);
		bulletInst.set_global_position(global_position);
		var shootStrength = shootSpeed * bulletInst.mass
		
		bulletInst.apply_impulse(Vector2(), shootSpeed*shootdir)
		
		bulletRef = weakref(bulletInst)
		
	if (Input.is_action_just_pressed("tele") and bulletRef != null and bulletRef.get_ref()):
		if dashes > 0:
			BulletSwap(self, bulletRef.get_ref()); #Swap positions with bullet if have dashes left
			dashes -= 1;
	
	if (Input.is_action_pressed("mv_right")):
		motion.x += 1;
	if (Input.is_action_pressed("mv_left")):
		motion.x -= 1;
	if (Input.is_action_pressed("mv_up")):
		if (jumpClock < jumpTime):
			jumping = true
			jumpClock += jumpTime+1;
			jumpDebounceClock = 0;
			#canJump = false;
	if (Input.is_action_pressed("mv_down")):
		motion.y += 1;
		
	var accel = Vector2()
	if (groundChecker.grounded):
		accel.x = (motion.x - linear_velocity.x/maxHoriSpeed) * groundaccel
	else:
		if (motion.x == 0):
			pass
		else:
			accel.x = (motion.x - linear_velocity.x/maxHoriSpeed) * airaccel
			
	
	motion = motion.normalized();
	
	var new_impulse = accel * delta;
	new_impulse += gravity;
	if (jumping == true):
		linear_velocity.y = jumpStrength;
	
	#	Set default animation to idle in direction currently facing	
	if cur_anim in ["BlinkRight", "BlinkLeft"]:
		pass
	elif cur_anim in ["RunRight", "Idle"]:
		new_anim = "Idle";
	else:
		new_anim = "IdleLeft"
		
	if motion.x > 0:
		new_anim = "RunRight";
	elif motion.x < 0:
		new_anim = "RunLeft";
	
	animate(new_anim);

	apply_impulse(Vector2(), new_impulse)
	
func _draw():
	for dash_line in dashLines:
		draw_line(dash_line[0] - global_position, dash_line[1] - global_position, Color(1, 1, .15, dash_line[2]/dashLineTime), 10, false);
	
	for blood_splat in bloodSplats:
		draw_circle(blood_splat[0] - global_position, bloodSplatRadius, Color(1, 0, 0, blood_splat[1]/bloodSplatTime));
	
	for i in range(dashes):
		draw_line(Vector2(get_viewport().size.x/2 - 96 - i*64, 64-get_viewport().size.y/2) - global_position + camera.global_position, Vector2(get_viewport().size.x/2 - 96 - i*64, 128-get_viewport().size.y/2) - global_position + camera.global_position, Color(1, 1, .15, .8), 48, false);
	
func _ready():
	anim.play("Idle");
	parent = self
	grandparent = get_node("..")
	
	camera = get_node("/root").get_child(0).find_node("Camera2D");
	
	connect("body_entered", self, "_on_Player_body_entered");
	
	set_contact_monitor(true);
	set_max_contacts_reported(5);

"""func _on_Floor_collided():
	#canJump = true
	jumpClock = 0;
	dashes = dashNum"""

"""func _integrate_forces(state):
	if (state.linear_velocity.length() > termvel):
		state.linear_velocity = state.linear_velocity.normalized() * termvel;"""
	

#Swap positions and velocities with the bullet
func BulletSwap(p, b):
	die = false;
	dashLines.push_back([p.global_position, b.global_position, dashLineTime]);
	var checkEnemies = get_node("Dash");
	checkEnemies.global_position = global_position;
	checkEnemies.cast_to = b.global_position - p.global_position;
	checkEnemies.force_raycast_update();
	while checkEnemies.is_colliding(): #Need to check multiple times in case you pass through several enemies
		var enemyPosition = null;
		var enemy = checkEnemies.get_collider();
		if enemy.is_in_group("shield"): #If you hit the shield part of an enemy
			die = true;
			print("Ran into a shield");
			break;
		elif enemy.get_parent().is_in_group("enemy"):
			enemyPosition = enemy.global_position;
			bloodSplats.push_back([enemyPosition, bloodSplatTime]);
			for child in enemy.get_children(): #Delete the enemy and its children if it has been dashed through
				child.free();
			enemy.get_parent().free();
			dashes += 1
		else:
			enemyPosition = checkEnemies.get_collision_point() + (b.global_position - p.global_position).normalized() * resolution_factor;
		
		if enemyPosition != null:
			checkEnemies.global_position = enemyPosition; #Check from where the first enemy was killed to end
			checkEnemies.cast_to = b.global_position - checkEnemies.global_position;
			checkEnemies.force_raycast_update();
		
	if !die: #If you switched without dying
		var temp = b.global_position
		b.global_position = p.global_position
		p.global_position = temp
		var templin = b.linear_velocity;
		b.linear_velocity = p.linear_velocity
		p.linear_velocity = templin
	else: #If you died when switching
		var temp = b.global_position
		b.global_position = p.global_position
		p.global_position = checkEnemies.get_collision_point()
		b.linear_velocity = p.linear_velocity
		Death();
		
		
func Death():
	RestartLevel();
	
func RestartLevel():
	get_tree().reload_current_scene();

func _on_Enemy_collided():
	print("Hit by an enemy");
	Death();

func _on_Spikes_collided():
	print("Hit spikes")
	Death();

func _on_Player_body_entered(body):
	if body.is_in_group("dangerblock"):
		_on_Spikes_collided();
	if (body.is_in_group("enemy") or body.get_parent().is_in_group("enemy")):
		_on_Enemy_collided();