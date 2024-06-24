extends Node

var stats = Stats
var utils = Utils

var dev_mode = stats.dev_mode

var default_save_path
var SAVE_DATA_PATH
var SAVE_SETTINGS_PATH

var default_save_data = stats.return_new_save_data()

func _ready():
	var logged_settings_path
	if !dev_mode:
		var dir = DirAccess.open("user://")
		if !dir.dir_exists("save_data"):
			dir.make_dir("save_data")
	if dev_mode:
		logged_settings_path = "user://settings.cfg"
		default_save_path = "user://dev_save_data.dat"
	else:
		logged_settings_path = "user://settings.cfg"
		default_save_path = "user://game_save_data.dat"
	SAVE_SETTINGS_PATH = logged_settings_path
	SAVE_DATA_PATH = default_save_path

func save_all():
	update_save_data()
	update_settings()

func save_data_to_file(save_data):
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_data_from_file():
	if not FileAccess.file_exists(SAVE_DATA_PATH):
		return default_save_data
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.READ)
	var save_data = file.get_var()
	if !save_data:
		push_error("corrupted")
		return default_save_data
	if str(save_data.version) <= str(default_save_data.version):
		save_data = check_old_data(save_data)
		return save_data
	elif str(save_data.version) > str(default_save_data.version):
		get_tree().change_scene_to_file("res://menus/new_version_screen.tscn")
		return false

func update_save_data():
	var save_data = load_data_from_file()
	for stat in stats.save_data:
		save_data[stat] = stats.save_data[stat]
	SaveAndLoad.save_data_to_file(save_data)
	#load_data()

func load_data():
	var save_data = load_data_from_file()
	if save_data:
		for stat in save_data:
			if typeof(save_data[stat]) == 27:
				stats["save_data"][stat] = await load_dictionary(save_data[stat])
			else:
				stats["save_data"][stat] = save_data[stat]
		return true
	else:
		return false

func load_dictionary(save_data):
	var stats_save = {}
	for sub_stat in save_data:
		if typeof(save_data[sub_stat]) == 27:
			stats_save[sub_stat] = await load_dictionary(save_data[sub_stat])
		else:
			stats_save[sub_stat] = save_data[sub_stat]
	return stats_save

func check_old_data(save_data):
	var version = default_save_data.version
	update_data(save_data,default_save_data)
	save_data.version = version
	return save_data

func update_data(save_data,default_data):
	for data in default_data:
		if !data in save_data:
				save_data[data] = default_data[data]
		if typeof(save_data[data]) == 27:
			update_data(save_data[data],default_data[data])
	return save_data

func update_settings():
	var settings = ConfigFile.new()
	settings.set_value("volume_settings","setting",utils.volume_settings)
	settings.set_value("window_mode","setting",utils.window_mode)
	settings.save(SAVE_SETTINGS_PATH)

func load_settings():
	var settings = ConfigFile.new()
	var err = settings.load(SAVE_SETTINGS_PATH)
	if err != OK:
		return
	for setting in settings.get_sections():
		var single_setting = settings.get_value(setting, "setting")
		utils[setting] = single_setting
