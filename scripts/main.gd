extends Node2D

# Spawn areas
@onready var spawn_area_1: Marker2D = $"spawn area/Marker2D"
@onready var spawn_area_2: Marker2D = $"spawn area/Marker2D2"
@onready var spawn_area_3: Marker2D = $"spawn area/Marker2D3"
@onready var spawn_area_4: Marker2D = $"spawn area/Marker2D4"
@onready var spawn_area_5: Marker2D = $"spawn area/Marker2D5"
@onready var spawn_area_6: Marker2D = $"spawn area/Marker2D6"
@onready var spawn_area_7: Marker2D = $"spawn area/Marker2D7"
@onready var spawn_area_8: Marker2D = $"spawn area/Marker2D8"
@onready var spawn_area_9: Marker2D = $"spawn area/Marker2D9"

var spawn_areas: Array[Marker2D] = []

# Enemies
const ENEMY_1 = preload("res://nodes/enemy1.tscn")

@onready var game_manager: Node = $GameManager
@onready var typing_container: Control = $TypingContainer

# Letters
const A = preload("res://nodes/a.tscn")
const B = preload("res://nodes/b.tscn")
const C = preload("res://nodes/c.tscn")
const D = preload("res://nodes/d.tscn")

# Spawn settings
var spawn_timer := 0.0
var spawn_interval := 3.0
var min_spawn_interval := 0.8
var spawn_acceleration := 0.01

# Word pool
var word_pool = {
	4: [
		"fire", "wind", "dark", "gate", "mist", "soul", "burn", "claw", "doom", "howl",
		"bane", "dust", "fear", "void", "icey", "toad", "rock", "heat", "coal", "bolt",
		"fume", "scar", "bark", "haze", "grip", "snap", "gnaw", "fang", "sing", "drip",
		"evil", "ash", "spit", "trap", "flux", "flip", "grow", "inch", "pain", "ache",
		"glow", "fuel", "hurt", "kick", "push", "spin", "dive", "lock", "sink", "jump"
	],
	5: [
		"flame", "curse", "ghost", "magic", "grave", "shock", "cloud", "storm", "chill", "haunt",
		"venom", "spell", "toxic", "blast", "blood", "night", "frost", "demon", "ghoul", "dread",
		"amber", "witch", "guard", "sting", "snake", "swamp", "crack", "flare", "blaze", "smite",
		"razor", "sloth", "swarm", "blink", "quake", "flint", "briar", "fable", "hatch", "latch",
		"singe", "creep", "coven", "shade", "grasp", "rotor", "thorn", "wound", "spear", "vapor"
	],
	6: [
		"poison", "shadow", "spirit", "dagger", "terror", "hammer", "wizard", "monster", "silence", "cursed",
		"ashes", "frozen", "hunter", "mirror", "energy", "triton", "knight", "abyss", "frenzy", "blight",
		"socket", "phantom", "locked", "struck", "tangle", "spider", "attack", "musket", "anchor", "hollow",
		"riddle", "target", "temple", "vanish", "flicks", "scream", "burrow", "serpent", "snakes", "warden",
		"savage", "sickle", "ignite", "summon", "spells", "ravage", "strike", "glitch", "drench", "bottle"
	],
	7: [
		"eruption", "haunting", "thunder", "barrier", "binding", "trident", "phantom", "cyclone", "draining", "rapture",
		"twisted", "revenge", "choking", "torment", "flicker", "grapple", "casting", "blaster", "crawler", "scorched",
		"stormer", "darkens", "rupture", "fracture", "venomous", "cursedly", "chilling", "deepcut", "grimace", "fiendish",
		"creeping", "rotters", "floaten", "stormed", "inflict", "grinder", "smother", "prowler", "clatter", "lurking",
		"voiding", "trouble", "revenge", "rattler", "stalker", "mystery", "grumble", "soulsap", "flaming", "grinder"
	],
	8: [
		"skeleton", "nightmare", "wildfire", "obsidian", "tormentor", "freezing", "collapse", "blizzard", "infernal", "trapdoor",
		"suffering", "mortality", "fractures", "oblivion", "grimness", "outbreak", "deadzone", "watchers", "darkness", "backlash",
		"shockwave", "slowburns", "soulbinds", "horrorize", "smoulder", "catapult", "fleshrot", "spellsaw", "frostbite", "ravaging",
		"sabotage", "betrayed", "lockstep", "fearborn", "combuster", "icequake", "cloudfog", "dreadfog", "necrokey", "deepmire",
		"soulseal", "grindbone", "stormfog", "boneyard", "netherly", "coldmist", "hellfire", "grimfade", "ghastful", "shadowed"
	],
	9: [
		"summoning", "necromancy", "possession", "incanting", "devastator", "withering", "resurrect", "corruption", "obliterate", "soulstrike",
		"blackmist", "dreamfire", "bonecrusher", "deathtrap", "stormgate", "fireblast", "spellbind", "wrathbone", "mindshock", "fearbound",
		"overthrow", "starbound", "forcecast", "gravefire", "deathbind", "chaospath", "godstrike", "darkshock", "burnforce", "mindtouch",
		"doomspell", "warcaller", "voidbeast", "ghostfire", "frostzone", "zombifier", "soulstorm", "grimdeath", "voidlight", "thundersky",
		"witchborn", "hellshade", "dreadpath", "soulmourn", "soulreign", "nethergem", "riftweaver", "voidtouch", "ghostborn", "hexcaster"
	],
	10: [
		"apocalypse", "cataclysm", "thunderous", "soulburning", "incinerator", "obliterator", "reanimation", "exterminator", "devastation", "shadowveil",
		"demonology", "ruinbringer", "hellstrike", "commandant", "deadbreaker", "stormdriven", "curseblade", "blightbane", "grimreaper", "spellcraft",
		"nightshade", "deathwatch", "soulreaver", "hellforged", "dreamshock", "voidcaster", "spellmancer", "nightmarez", "doomblaster", "netherborn",
		"blackforge", "firemancer", "deathangel", "rottinggod", "chaosdrain", "stormreign", "deathflame", "doomshadow", "dreadburst", "ghoulhunter",
		"voidmaster", "riftwalker", "bloodweaver", "chaosreign", "soulbreaker", "darkseeker", "spellhunter", "phantasmic", "infernight", "voidscream"
	]
}

var letter_scenes = {
	KEY_A: A,
	KEY_B: B,
	KEY_C: C,
	KEY_D: D
}


func _ready() -> void:
	spawn_areas = [
		spawn_area_1, spawn_area_2, spawn_area_3,
		spawn_area_4, spawn_area_5, spawn_area_6,
		spawn_area_7, spawn_area_8, spawn_area_9
	]

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_interval = max(min_spawn_interval, spawn_interval - spawn_acceleration)
		spawn_timer = spawn_interval

func spawn_enemy() -> void:
	var enemy = ENEMY_1.instantiate()
	var area = spawn_areas.pick_random()
	enemy.global_position = area.global_position

	var word_length = randi_range(4, 10)
	var word_list = word_pool.get(word_length, [])
	if word_list.size() > 0:
		enemy.word = word_list.pick_random()

	add_child(enemy)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key = event.keycode
		if letter_scenes.has(key):
			var letter_instance = letter_scenes[key].instantiate()
			typing_container.add_child(letter_instance)
