extends Node3D

var stats = Stats
var sounds = Sounds
var timer = GlobalTimer

@onready var moveable_tornado = $moveable_tornado
@onready var transition = $CanvasLayer/transition


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	transition.fade_in()
	sounds.play_music("tornado_music")
	timer.connect("finish_level",finish_level)
	timer.reset_timer()
	timer.timer_on = true

func finish_level():
	stats["save_data"]["current_run_data"]["level"] = moveable_tornado.tornado_level
	if moveable_tornado.tornado_level > stats["save_data"]["level_data"]["level_1"]["highest_level"]:
		stats["save_data"]["level_data"]["level_1"]["highest_level"] = moveable_tornado.tornado_level
	if stats["save_data"]["level_data"]["level_1"]["first_clear"] == 0:
		stats["save_data"]["level_data"]["level_1"]["first_clear"] = moveable_tornado.tornado_level
	SaveAndLoad.update_save_data()
	transition.fade_out()
	get_tree().call_deferred("change_scene_to_file","res://menus/finish_scene.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/tornado_level.text = "Power-%s" % [str(moveable_tornado.tornado_level)]

#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		#$CanvasLayer/pause_menu.show()
		#get_tree().paused = true
#
#func _on_resume_pressed():
	#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	#$CanvasLayer/pause_menu.hide()
	#get_tree().paused = false

func _on_main_menu_pressed():
	sounds.play_sfx("click",randf_range(.8,1.2),-10)
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
