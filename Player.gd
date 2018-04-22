extends RigidBody2D

var bulletFab = preload("res://Bullet.tscn");

var parent;
var grandparent;
var bulletRef = null;
var shootSpeed = 500;
var motion = Vector2();
var new_impulse = Vector2();
var gravity = Vector2(0, 10);
var jumpStrength = -500;
var speed = 1000;
var jumping = Vector2(0,0);
var canJump = false;
var die = false;

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
	motion = Vector2(0,0);
	jumping = Vector2(0,0);
	var space_state = get_world_2d().get_direct_space_state()
	
	if (Input.is_action_just_pressed("shoot")):
		if (bulletRef != null and bulletRef.get_ref()):
			bulletRef.get_ref().queue_free()
			bulletRef = null
			pass
		
		# OPTION: Mouse-based
		var mouse_pos_diff = (get_global_mouse_position() - global_position);
		var shootdir = mouse_pos_diff.normalized();
		
		var bulletInst = bulletFab.instance();
		grandparent.add_child(bulletInst);
		bulletInst.set_global_position(global_position);
		var shootStrength = shootSpeed * bulletInst.mass
		
		bulletInst.apply_impulse(Vector2(), shootSpeed*shootdir)
		
		bulletRef = weakref(bulletInst)
		
	if (Input.is_action_just_pressed("tele") and bulletRef != null and bulletRef.get_ref()):
		BulletSwap(self, bulletRef.get_ref());
	
	if (Input.is_action_pressed("mv_right")):
		motion.x += 1;
	if (Input.is_action_pressed("mv_left")):
		motion.x -= 1;
	if (Input.is_action_pressed("mv_up")):
		if canJump:
			jumping = Vector2(0,jumpStrength);
			canJump = false;
	if (Input.is_action_pressed("mv_down")):
		motion.y += 1;
		
	motion = motion.normalized();
	
	new_impulse = motion * delta * speed;
	new_impulse += gravity;
	new_impulse += jumping;
	
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
	

	
func _ready():
	anim.play("Idle");
	parent = get_node("self")
	grandparent = get_node("..")
	
	set_contact_monitor(true);
	set_max_contacts_reported(5);

func _on_Floor_collided():
	canJump = true;

func BulletSwap(p, b):
	die = false;
	var checkEnemies = get_node("Dash");
	checkEnemies.cast_to = b.global_position - p.global_position;
	checkEnemies.force_raycast_update();
	if checkEnemies.is_colliding():
		var enemy = checkEnemies.get_collider();
		if enemy.is_in_group("shield"):
			die = true;
		elif enemy.get_parent().is_in_group("enemy"):
			enemy.get_parent().free();
			
	if !die:
		var temp = b.global_position
		b.global_position = p.global_position
		p.global_position = temp
		var templin = b.linear_velocity;
		b.linear_velocity = p.linear_velocity
		p.linear_velocity = templin
	else:
		var temp = b.global_position
		b.global_position = p.global_position
		p.global_position = checkEnemies.get_collision_point()
		b.linear_velocity = p.linear_velocity