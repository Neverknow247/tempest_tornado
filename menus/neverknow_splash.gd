extends TextureRect

var stats = Stats
var sounds = Sounds
var utils = Utils

@onready var transition = $transition
@onready var easter_egg_button = $easter_egg_button

var easter_egg_audio = "angel_1_1"
var opening_board = "res://menus/main_menu.tscn"

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	sounds.play_sfx("smell_this_bread",1,-15)
	await get_tree().create_timer(1.2).timeout
	easter_egg_button.disabled = false
	await get_tree().create_timer(1).timeout
	easter_egg_button.disabled = true
	await get_tree().create_timer(.3).timeout
	start()

func start():
	await SaveAndLoad.load_settings()
	utils.set_volume()
	if await SaveAndLoad.load_data():
		stats["save_data"]["stats"]["power_on_count"] += 1
		await SaveAndLoad.save_all()
		finish()

func finish():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file(opening_board)

func _on_easter_egg_button_pressed():
	easter_egg_button.disabled = true
	sounds.play_voice(easter_egg_audio,1,-10)
