extends CanvasLayer
#var tower_range = 350

func set_tower_preview(tower_type, mouse_position):

	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff")
	
	#setting the range_overlay behavior
	#create a new sprite and offset it so it centers on the tower
	var range_texture = Sprite2D.new()
	# Actually, it is centered perfectly without the offset - I don't know where this offset comes from.
	#range_texture.position = Vector2(32, 32)
	#scale the size
	#var scaling = tower_range / 600.0
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	
	#load the range_overlay asset
	var texture = load("res://Assets/Environment/Tilesets/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.set_position(mouse_position)
	control.set_name("TowerPreview")
	add_child(control, true)
	#move the node up (index 0) so that it gets rendered behind the other elements.
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").set_position(new_position)
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)

##
## Game Control Functions
##

#Toggle the PlayPause button
func _on_pause_play_pressed() -> void:
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
		# 'current_wave' is a 'GameScene.gd' variable initialized to 0
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true
		
		
func _on_speed_up_pressed() -> void:
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
