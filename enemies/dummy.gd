extends RigidBody2D

var health = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		print_debug("dummy died :(")
		queue_free()
	


func _on_body_entered(body):
	pass


#detects if an area has entered the hitbox
func _on_hitbox_area_entered(area):
	print_debug("something touched the dummy")
	if area.is_in_group("pBullet"):
		print_debug("dummy took damage")
		print_debug("current dummy health: " + str(health))
		health -= 1
		
