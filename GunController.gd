extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var bulletFab = preload("res://Bullet.tscn");

var parent;
var grandparent;
#var bulletInst = null;
var bulletRef = null;
var shootSpeed = 500;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	parent = get_node("..")
	grandparent = get_node("../..")
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	var space_state = get_world_2d().get_direct_space_state()
	#if (bulletInst == null and (Input.is_action_just_pressed("shoot_up") or Input.is_action_just_pressed("shoot_down") or Input.is_action_just_pressed("shoot_left") or Input.is_action_just_pressed("shoot_right") ) ): # Input.is_action_just_pressed("grappleShoot")): #(Input.is_action_just_pressed("ropeShoot") or Input.is_action_just_pressed("grappleShoot")):
	
	#Key Based
	"""shootdir = Vector2();
	if(Input.is_action_just_pressed("shoot_up")):
		shootdir.y -= 1;
	if(Input.is_action_just_pressed("shoot_down")):
		shootdir.y += 1;
	if(Input.is_action_just_pressed("shoot_left")):
		shootdir.x -= 1;
	if(Input.is_action_just_pressed("shoot_right")):
		shootdir.x += 1;"""
	#Mouse Based
	if (Input.is_action_just_pressed("shoot")):
		if (bulletRef != null and bulletRef.get_ref()):
			bulletRef.get_ref().queue_free()
			bulletRef = null
			pass
		
		# OPTION: Mouse-based
		var mouse_pos_diff = (get_global_mouse_position() - global_position);
		var shootdir = mouse_pos_diff.normalized();

		# OPTION: Key-Based
		#shootdir = shootdir.normalized()
		
		
		var bulletInst = bulletFab.instance();
		grandparent.add_child(bulletInst);
		bulletInst.set_global_position(global_position);
		bulletInst.linear_velocity = parent.linear_velocity; #Eventually when doing non-inertial don't transfer this velocity
		var shootStrength = shootSpeed * bulletInst.mass
		print(shootSpeed*shootdir)
		
		#Change this physics to be non inertial!!!!!!!!!!
		bulletInst.apply_impulse(Vector2(), shootSpeed*shootdir)
		#parent.apply_impulse(Vector2(), -shootStrength*shootdir / parent.mass)
		
		bulletRef = weakref(bulletInst)
		
	"""if (bulletInst != null):
		print (bulletInst.get_parent().name)
	else:
		print("it's null");"""
	#print (bulletInst.)
	#print (grandparent.has_node("Bullet"))
	if (Input.is_action_just_pressed("tele") and bulletRef != null and bulletRef.get_ref()):
		BulletSwap(parent, bulletRef.get_ref());
		
func BulletSwap(p, b):
	var temp = b.global_position
	b.global_position = p.global_position
	p.global_position = temp
	var templin = b.linear_velocity;
	b.linear_velocity = p.linear_velocity
	p.linear_velocity = templin