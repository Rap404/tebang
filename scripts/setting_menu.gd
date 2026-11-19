extends Control

@onready var persen_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/persenLabel

func _update_label(value: float) -> void:
	persen_label.text = str(roundi(value * 100)) + "%"

func _on_btn_back_pressed() -> void:
	hide()
