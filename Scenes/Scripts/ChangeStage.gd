extends Area2D


export(String, FILE, "*.tscn") var targer_stage


func _ready():
    pass


func _on_ChangeStage_body_entered(body):
    if "Player" in body.name:
        print('entered!')
        get_tree().change_scene(targer_stage)
