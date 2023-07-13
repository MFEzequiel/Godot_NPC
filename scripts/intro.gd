extends Control

export (PackedScene) var _change

func _on_anim_animation_finished(_anim_name):
	get_tree().change_scene_to(_change)