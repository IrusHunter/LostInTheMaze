class_name Global
## contains global gata about the program and 
## serves as a container for non constant vars for external use

static var options_gata: OptionsData ## contain general information about the program
static var game_data: GameData ## general data about current game
static var level_data: LevelData ## general information about level

const dialogue_path = "res://UserData/Dialogue"
const start_data_path = "res://UserData/StartData/"
const user_path = "user://Data/"
const init_unit_path = "user://Data/for_init_units.txt"
const saves_path = user_path + "Saves/"


static var void_visibility: bool = false
