extends CharacterBody2D

const LAVA_LAYER = 1 << (2 - 1)    # collision layer 2
#const ITEM_BLOCK_LAYER = 1 << (6 - 1)  # collision layer 6
var layer_of_collision = null

@export var speed: float = 120.0
@export var jump_velocity: float = -200.0
var health = 3
var player_alive = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var collider: CollisionShape2D = $CollisionShape2D
# access the animated sprite
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var animation_locked: bool = false
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "down", "up")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var collision = move_and_slide()
	if collision:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap:
			var tile_rid = get_last_slide_collision().get_collider_rid()
			layer_of_collision = PhysicsServer2D.body_get_collision_layer(tile_rid)
	
	if layer_of_collision == LAVA_LAYER:
		print_debug("touched laba")
		velocity.y = jump_velocity * 1.2
		layer_of_collision = null

	#move_and_slide()
	updateAnimation()
	updateMovingDirection()
func updateAnimation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

func updateMovingDirection():
	if direction.x > 0:
		animated_sprite.flip_h = false
	if direction.x < 0:
		animated_sprite.flip_h = true;


