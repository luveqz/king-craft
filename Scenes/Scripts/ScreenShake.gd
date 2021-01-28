extends Node2D

var current_shake_priority = 0


func _ready():
    pass


func move_camera(vector):
    var offset = Vector2(
        rand_range(-vector.x, vector.x),
        rand_range(-vector.y, vector.y)
    )
    get_parent().get_node("Player/Camera2D").offset = offset


func shake(length, power, priority):
    if priority > current_shake_priority:
        current_shake_priority = priority
        $Tween.interpolate_method(
            self,
            "move_camera",
            Vector2(power, power),
            Vector2(),
            length,
            Tween.TRANS_SINE,
            Tween.EASE_OUT,
            0
        )
        $Tween.start()


func _on_Tween_tween_completed(object, key):
    current_shake_priority = 0
