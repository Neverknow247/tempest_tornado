extends Control

var stats = Stats

@onready var highest = $highest
@onready var power = $power

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	power.text = "Your Power: %s" % [str(stats["save_data"]["current_run_data"]["level"])]
	highest.text = "Highest Power: %s" % [str(stats["save_data"]["level_data"]["level_1"]["highest_level"])]



func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://level/tornado_world.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
