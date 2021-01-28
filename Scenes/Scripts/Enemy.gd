extends KinematicBody2D


const GRAVITY = 10
const FLOOR = Vector2(0, -1)


export(int) var speed = 30
export(int) var hp = 1
export(Vector2) var size = Vector2(1, 1)


var velocity = Vector2()
var direction = 1
var is_dead = false


func _ready():
    scale = size


func dead():
    is_dead = true
    velocity = Vector2()
    $AnimatedSprite.play("dead")
    $CollisionShape2D.set_deferred("disabled", true)
    $Timer.start()
    
    if scale > Vector2(1, 1):
        get_parent().get_node("ScreenShake").shake(1, 10, 100)


func damage(points):
    hp -= points
    if hp <= 0:
        dead()
    else:
        $AnimationPlayer.play("Damage_Blink")


func _physics_process(delta):
    if not is_dead:
        velocity.y += GRAVITY
        velocity.x = speed * direction

        $AnimatedSprite.play("walk")
        velocity = move_and_slide(velocity, FLOOR)
    
        if is_on_wall() or not $RayCast2D.is_colliding():
            direction *= -1
            $AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
            $RayCast2D.position.x *= -1
        
        if get_slide_count() > 0:
            for i in range(get_slide_count()):
                if "Player" in get_slide_collision(i).collider.name:
                    get_slide_collision(i).collider.dead()


func _on_Timer_timeout():
    queue_free()
