extends Node

var dev_mode = false

var transition_time = .25

const level_num = 1

var new_run_data = {
	"level" : 1,
}

var new_save_data = {
	"version" : ProjectSettings.get_setting("application/config/version"),
	"current_run_data" : new_run_data.duplicate(true),
	"stats" : {
		"power_on_count" : 0,
	},
	"achievements" : {
		
	},
	"level_data" : {},
}

var new_level_data = {
	"unlocked" : false,
	"first_clear" : 0,
	"highest_level" : 0,
}

var save_data = return_new_save_data()

func return_new_save_data():
	var new_data = new_save_data.duplicate(true)
	for level in level_num:
		var level_name = "level_%s" % [str(level+1)]
		new_data["level_data"][level_name] = new_level_data.duplicate(true)
	new_data["level_data"]["level_1"]["unlocked"] = true
	return new_data

func reset_run():
	save_data["current_run_data"] = new_run_data.duplicate(true)

func delete_save():
	save_data = return_new_save_data()
