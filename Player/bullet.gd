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
	if killNumber >= 50:
		queue_free()
	

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()


func _on_body_entered(body):
	queue_free()
