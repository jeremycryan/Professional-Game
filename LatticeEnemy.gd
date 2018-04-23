extends Area2D

export (float) var omega = 1000
export (float) var v = 0
export (float) var vmax = 0
export (float) var sightRange = 0
export (bool) var aim = false
var links = [];
var numLinksMakeInvincible = 3;
var linkWidth = 5;

var player

func _process(delta):
	for child in get_node("/root").find_node("Enemies").get_children():
		if child.
	
	for child in get_parent().find_node("Linkage").get_children():
		if (child != get_parent().find_node("Linkage").find_node("Armor") and child != get_parent().find_node("Linkage").find_node("Sprite")):
			child.free();
	
	for link in links:
		var shape = ConvexPolygonShape2D.new();
		var shapePoints = PoolVector2Array();
		var collision = CollisionShape2D.new();
		shapePoints.append(global_position - Vector2(linkWidth/2, 0));
		shapePoints.append(global_position + Vector2(linkWidth/2, 0));
		shapePoints.append(link[0].global_position + Vector2(linkWidth/2, 0));
		shapePoints.append(link[0].global_position - Vector2(linkWidth/2, 0));
		shape.points = shapePoints;
		collision.set_shape(shape);
		get_parent().find_node("Linkage").add_child(collision);
		link[1] = shape;
	update();

#func _ready():
#	connect("body_entered", self, "_check_for_links");
#	connect("body_exited", self, "_remove_links");


func _check_for_links(body):
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
		get_parent().find_node("Linkage").add_child(collision);
		links.push_back([body, collision]);
		
func _remove_links(body):
	if body.is_in_group("link"):
		for i in range(links.size() - 1):
			if links[i][0] == body:
				links.remove(i);
				break;
		
func _draw():
	for link in links:
		draw_line(Vector2(0,0), link[0].global_position - global_position, Color(1, 1, .15, .8), 5, false);
		
	if links.size() >= numLinksMakeInvincible:
		draw_circle(Vector2(0,0), 64, Color(1, 1, .15, .3));