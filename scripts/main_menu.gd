extends Control

func _on_mulai_button_pressed() -> void:
	# Pindah ke scene gameplay kamu yang sekarang
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_keluar_button_pressed() -> void:
	get_tree().quit()
