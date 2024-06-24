extends Node

var stats = Stats

const master_bus_name = "Master"
const music_bus_name = "Music"
const sfx_bus_name = "SFX"
const voice_bus_name = "Voice"

@onready var master_bus = AudioServer.get_bus_index(master_bus_name)
@onready var music_bus = AudioServer.get_bus_index(music_bus_name)
@onready var sfx_bus = AudioServer.get_bus_index(sfx_bus_name)
@onready var voice_bus = AudioServer.get_bus_index(voice_bus_name)

var volume_settings = {
	"master_volume" = .5,
	"music_volume" = 1,
	"sfx_volume" = 1,
	"voice_volume" = 1
}

var window_mode = 4:
	get:
		return window_mode
	set(value):
		window_mode = value
		DisplayServer.window_set_mode(value)

func _ready():
	if DisplayServer.window_get_mode() != window_mode:
		DisplayServer.window_set_mode(window_mode)

func set_volume():
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(volume_settings["master_volume"]))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(volume_settings["music_volume"]))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(volume_settings["sfx_volume"]))
	AudioServer.set_bus_volume_db(voice_bus, linear_to_db(volume_settings["voice_volume"]))
