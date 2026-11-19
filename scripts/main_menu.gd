extends Control

func _on_mulai_button_pressed() -> void:
	# Pindah ke scene gameplay kamu yang sekarang
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_keluar_button_pressed() -> void:
	get_tree().quit()
	
func _on_pengaturan_button_pressed() -> void:
	$SettingMenu.show()
func _on_creadit_button_pressed() -> void:
	$CreaditMenu.show()
	
func _on_btn_back_pressed() -> void:
	hide()
