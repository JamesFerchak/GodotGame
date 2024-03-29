extends CharacterBody2D

#variable to hold bullet
@export var bullet : PackedScene


const LAVA_LAYER = 1 << (2 - 1)    # collision layer 2
#const ITEM_BLOCK_LAYER = 1 << (6 - 1)  # collision layer 6
var layer_of_collision = null

@export var speed: float = 120.0
@export var jump_velocity: float = -200.0
var health = 3
var player_alive = true
var iFrames = false
var stun = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var marker: Marker2D = $Marker2D
# access the marker for bullet shooting

@onready var collider: CollisionShape2D = $CollisionShape2D
# access the animated sprite
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var animation_locked: bool = false
var was_in_air: bool = false
var direction : Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		kill()
		


func kill():
	get_tree().change_scene_to_file("res://main menu/main_menu.tscn")
	

func heal():
	health = 3



func _physics_process(delta):
	
	#handle velocity with stun active
	if stun == true:
		velocity.x = 0
	
	#i frame flashing
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true;
	else:
		if was_in_air == true:
			land()
		was_in_air = false
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if stun == false:
			jump()
		
	#check for shoot button + mag
	if Input.is_action_just_pressed("shoot"):
		if stun == false:
			shoot()
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "down", "up")
	if direction:
		if stun == false:
			velocity.x = direction.x * speed
	else:
		if stun == false:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	var collision = move_and_slide()
	if collision:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap:
			var tile_rid = get_last_slide_collision().get_collider_rid()
			layer_of_collision = PhysicsServer2D.body_get_collision_layer(tile_rid)
	
	if layer_of_collision == LAVA_LAYER:
		touched_lava()
	
	#move_and_slide()
	updateAnimation()
	updateMovingDirection()
	

func shoot():
	if get_tree().get_nodes_in_group("pBullet").size() < 3:
		$SoundEffectShoot.play()
		var b = bullet.instantiate()
		owner.add_child(b)
		b.transform = $Marker2D.global_transform

func jump():
	velocity.y = jump_velocity
	$SoundEffectJump.play()
	#animated_sprite.play("jump_start")
	#animation_locked = true

func land():
	if not animation_locked:
		$SoundEffectLand.play()
		animated_sprite.play("idle")

func updateAnimation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")

func updateMovingDirection():
	if direction.x > 0:
		animated_sprite.flip_h = false
		marker.position.x = 5
		marker.global_rotation_degrees = 0
	if direction.x < 0:
		animated_sprite.flip_h = true
		marker.position.x = -5
		marker.global_rotation_degrees = 180

func touched_lava():
	print_debug("touched laba")
	if iFrames == false:
		hurt()
	print_debug("current health: " + str(health))
	# animation_locked = true
	velocity.y = jump_velocity * 1.2
	layer_of_collision = null

func hurt():
	health -=1
	$InvFrameTimer.start()
	$stunTimer.start()
	$SoundEffectHurt.play()
	iFrames = true
	stun = true
	animated_sprite.play("hurt")
	animation_locked = true

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "idle" or animated_sprite.animation == "run":
		animation_locked = false


func _on_player_hitbox_body_entered(body):
	if iFrames == false:
		if body.is_in_group("enemies"):
			print_debug("enemy hit player/player hurt")
			hurt()
	


func _on_inv_frame_timer_timeout():
	iFrames = false


func _on_stun_timer_timeout():
	animation_locked = false
	stun = false
