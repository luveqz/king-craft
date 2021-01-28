extends Area2D


func _ready():
    $AnimationPlayer.play("Float")


func _on_PowerUp_body_entered(body):
    if "Player" in body.name:
        body.has_power_up = true
        queue_free()
