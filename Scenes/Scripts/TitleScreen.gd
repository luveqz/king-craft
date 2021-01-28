extends Node

onready var StartButton = get_node('MarginContainer/VBoxContainer/VBoxContainer/StartButton')
onready var ExitButton = get_node('MarginContainer/VBoxContainer/VBoxContainer/ExitButton')


func _ready():
	StartButton.grab_focus()


func _physics_process(delta):
	if StartButton.is_hovered():
		StartButton.grab_focus()
	elif ExitButton.is_hovered():
		ExitButton.grab_focus()


func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Stage_01.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
