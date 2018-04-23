extends Area2D

var numLinksMakeInvincible = 3;
var linkWidth = 20;
var updateTimer = 1; #Seconds between updates. Be careful of lag.
var updateTime = 0.1;
var links = [];

func _physics_process(delta):
	if updateTime > 0:
		updateTime -= delta;
	else:
		updateTime = updateTimer;
		print(get_overlapping_bodies().size());
		for body in get_overlapping_bodies():
			_check_for_links(body);
			
	if links.size() >= numLinksMakeInvincible:
		get_parent().find_node("Linkage").add_to_group("invincible");
	elif get_parent().find_node("Linkage").is_in_group("invincible"):
		get_parent().find_node("Linkage").remove_from_group("invincible");

func _check_for_links(body):
	for child in get_parent().find_node("Linkage").get_children():
		child.free();
		
	links = [];
	
	if (body.is_in_group("link") and body.get_parent() != get_parent()):
		var shape = ConvexPolygonShape2D.new();
		var shapePoints = PoolVector2Array();
		var collision = CollisionShape2D.new();
		shapePoints.append(global_position - Vector2(linkWidth/2, 0));
		shapePoints.append(global_position + Vector2(linkWidth/2, 0));
		shapePoints.append(body.global_position + Vector2(linkWidth/2, 0));
		shapePoints.append(body.global_position - Vector2(linkWidth/2, 0));
		shape.points = shapePoints;
		collision.set_shape(shape);
		collision.translate(-global_position);
		get_parent().find_node("Linkage").add_child(collision);
		links.push_back([body.global_position, collision]);
		collision.add_to_group("shield");
	update();

func _draw():
	for link in links:
		draw_line(Vector2(0,0), link[0] - global_position, Color(1, 1, .15, .8), linkWidth, false);
		
	if get_parent().find_node("Linkage").is_in_group("invincible"):
		draw_circle(Vector2(0,0), 64, Color(1, 1, .15, .3));