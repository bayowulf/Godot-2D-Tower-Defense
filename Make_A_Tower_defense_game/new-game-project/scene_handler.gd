extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MainMenu/M/VB/NewGame").connect("pressed", _on_new_game_pressed)
	get_node("MainMenu/M/VB/Quit").connect("pressed", _on_quit_pressed)
	
func _on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/game_scene.tscn")
	var instance = game_scene.instantiate()
	add_child(instance)
	
func _on_quit_pressed():
	get_tree().quit()
	
