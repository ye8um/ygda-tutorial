extends CharacterBody2D

const SPEED: int = 200
const DELAY_TILL_RESTART: float = 2
const JUMP_POWER: int = -300
const DISC = preload("res://Scenes/disc.tscn")
const BOUNCE_POWER: int = -250

var x_direction: int = 0
var is_dead: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_dead:
		move_and_slide()
		return
		
	if Input.is_action_pressed("Shoot") and $DiscCooldown.is_stopped():
		$DiscCooldown.start()
		var new_disc: Area2D = DISC.instantiate()
		new_disc.position = position
	
	# Downward shot (only in air)
		if Input.is_action_pressed("Down") and not is_on_floor():
			new_disc.x_direction = 0
			new_disc.y_direction = 1
			
			velocity.y = BOUNCE_POWER
		else:
			new_disc.y_direction = 0
			if $AnimatedSprite2D.flip_h:
				new_disc.x_direction = -1
			else:
				new_disc.x_direction = 1
	
		get_tree().current_scene.add_child(new_disc)
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += JUMP_POWER # Add the jump power
		
	if Input.is_action_pressed("Left"):
		x_direction = -1
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("Right"):
		x_direction = 1
		$AnimatedSprite2D.flip_h = false
	else:
		x_direction = 0
		
	velocity.x = x_direction * SPEED
	if is_on_floor():
		if x_direction !=0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y>0:
			$AnimatedSprite2D.play("fall")
		if velocity.y<0:
			$AnimatedSprite2D.play("jump")
	move_and_slide()
func die() -> void:
	is_dead = true
	set_deferred("velocity", Vector2.ZERO)
	$AnimatedSprite2D.flip_v = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	Engine.time_scale = 0.5
	await get_tree().create_timer(DELAY_TILL_RESTART).timeout
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/world.tscn")
