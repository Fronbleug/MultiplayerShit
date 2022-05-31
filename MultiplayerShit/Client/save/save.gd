extends Node

const SAVEGAME = "user://SaveGame.json"

var SaveData = {}

func _ready():
	SaveData = get_data()
	
func get_data():
	var file = File.new()
	
	if not file.file_exists(SAVEGAME):
		SaveData = {"PlayerName": "Unnamed"}
		save_game()
	file.open(SAVEGAME,File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	SaveData = data
	file.close()
	return(data)

func save_game():
	var savegame = File.new()
	savegame.open(SAVEGAME,File.WRITE)
	savegame.store_line(to_json(SaveData))
