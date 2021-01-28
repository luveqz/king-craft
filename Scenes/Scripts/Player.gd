extends KinematicBody2D


const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)
const FIREBALL = preload("res://Scenes/Fireball.tscn")
const TILES_OUT_OF_CAMERA = 2


var velocity = Vector2()
var on_ground = false
var is_recharging = false
var power_loaded = false
var is_dead = false
var has_power_up = false


func _ready():
	set_camera_right_limit()


func set_camera_right_limit():
	var tilemap = get_parent().get_node("Solids")
	var cell_witdh = tilemap.get_cell_size().x
	var rect = tilemap.get_used_rect()
	$Camera2D.limit_right = (
		(rect.position.x + rect.size.x - TILES_OUT_OF_CAMERA) * cell_witdh)


func shoot():
	var fireball = FIREBALL.instance()
	
	if has_power_up:
		fireball.has_power_up = true

	var direction = sign($Position2D.position.x)
	
	fireball.set_fireball_direction(direction)
	get_parent().add_child(fireball)
	fireball.position = $Position2D.global_position

	power_loaded = false


func listen_controlls():
	# --------------------------------------------------------------------------
	# Moving
	# --------------------------------------------------------------------------
	if Input.is_action_pressed("ui_right") and not is_recharging:
		velocity.x = SPEED
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1

	elif Input.is_action_pressed("ui_left") and not is_recharging:
		velocity.x = -SPEED
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true

		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1

	else:
		velocity.x = 0
		if on_ground and not is_recharging:
			$AnimatedSprite.play("idle")


	# --------------------------------------------------------------------------
	# Jumping
	# --------------------------------------------------------------------------
	if Input.is_action_pressed("ui_up") and not is_recharging:
		if on_ground:
			velocity.y = JUMP_POWER

	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if not is_recharging:
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
			
		else:
			$AnimatedSprite.play("recharge")

	velocity = move_and_slide(velocity, FLOOR)
	
	
	# --------------------------------------------------------------------------
	# Shooting
	# --------------------------------------------------------------------------
	if Input.is_action_pressed("ui_focus_next"):
		if not is_recharging:
			$AnimatedSprite.play("recharge")
			is_recharging = true
		
	
	if Input.is_action_just_released("ui_focus_next"):
		is_recharging = false
		$AnimatedSprite.stop()
		
		if power_loaded:
			shoot()
			
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				dead()


func _physics_process(delta):
	if not is_dead:
		listen_controlls()


func dead():
	is_dead = true
	velocity = Vector2()
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'recharge':
		power_loaded = true


func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func _on_VisibilityNotifier2D_screen_exited():
	print('screen exited: ' + str($Camera2D.limit_right))
	dead()
