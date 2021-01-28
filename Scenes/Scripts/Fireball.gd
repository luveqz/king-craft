extends Area2D


const SPEED = 200


var velocity = Vector2()
var direction = 1
var has_power_up = false


func _ready():
    pass


func set_fireball_direction(dir):
    direction = dir
    if dir == -1:
        $AnimatedSprite.flip_h = true 
    elif dir == 1:
        $AnimatedSprite.flip_h = false


func _physics_process(delta):
    velocity.x = SPEED * delta * direction
    translate(velocity)
    if has_power_up:
        $AnimatedSprite.play("power_up")
    else:
        $AnimatedSprite.play("normal")


func _on_VisibilityNotifier2D_screen_exited():
    queue_free()


func _on_Fireball_body_entered(body):
    if "Enemy" in body.name:
        if has_power_up:
            body.damage(2)
        else:
            body.damage(1)
    queue_free()
