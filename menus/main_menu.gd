extends Node3D

var stats = Stats
var sounds = Sounds

@onready var transition = $menu/Control/transition
@onready var highest = $menu/Control/highest


# Called when the node enters the scene tree for the first time.
func _ready():
	highest.text = "Highest Power: %s" % [str(stats["save_data"]["level_data"]["level_1"]["highest_level"])]
	get_tree().paused = false
	transition.fade_in()
	sounds.play_music("tornado_music")

func _on_start_pressed():
	sounds.play_sfx("click",randf_range(.8,1.2),-10)
	stats.reset_run()
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://level/tornado_world.tscn")

func _on_sounds_pressed():
	sounds.play_sfx("click",randf_range(.8,1.2),-10)
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	$menu/Control/volume_menu.show()
	transition.fade_in()

func _on_quit_pressed():
	get_tree().quit()


func _on_volume_menu_hide_menu(scene):
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	scene.hide()
	transition.fade_in()
