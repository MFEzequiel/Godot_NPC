extends Node



func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()
