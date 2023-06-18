extends Area2D

var speed = 150

@onready var collider: CollisionShape2D = $CollisionShape2D
var killNumber = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	killNumber += 1
	if killNumber >= 20:
		queue_free()
	

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		print_debug("hit enemy func 1")
		body.queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print_debug("hit enemy body")
		queue_free()
	else:
		queue_free()
	


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		print_debug("collided with enemy hurtbox")
		queue_free()
