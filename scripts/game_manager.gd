extends Node

var Health_Points = 100

var Booster_1_Count = 0
var Booster_2_Count = 0
var Booster_3_Count = 0

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
		"nightshade", "deathwatch", "soulreaver", "hellforged", "dreamshock", "voidcaster", "spellmancer", "nightmares", "doomblaster", "netherborn",
		"blackforge", "firemancer", "deathangel", "rottinggod", "chaosdrain", "stormreign", "deathflame", "doomshadow", "dreadburst", "ghoulhunter",
		"voidmaster", "riftwalker", "bloodweaver", "chaosreign", "soulbreaker", "darkseeker", "spellhunter", "phantasmic", "infernight", "voidscream"
	]
}

# Letters
const A = preload("res://nodes/a.tscn")
const B = preload("res://nodes/b.tscn")
const C = preload("res://nodes/c.tscn")
const D = preload("res://nodes/d.tscn")
const E = preload("res://nodes/e.tscn")
const F = preload("res://nodes/f.tscn")
const G = preload("res://nodes/g.tscn")
const H = preload("res://nodes/h.tscn")
const I = preload("res://nodes/i.tscn")
const J = preload("res://nodes/j.tscn")
const K = preload("res://nodes/k.tscn")
const L = preload("res://nodes/l.tscn")
const M = preload("res://nodes/m.tscn")
const N = preload("res://nodes/n.tscn")
const O = preload("res://nodes/o.tscn")
const P = preload("res://nodes/p.tscn")
const Q = preload("res://nodes/q.tscn")
const R = preload("res://nodes/r.tscn")
const S = preload("res://nodes/s.tscn")
const T = preload("res://nodes/t.tscn")
const U = preload("res://nodes/u.tscn")
const V = preload("res://nodes/v.tscn")
const W = preload("res://nodes/w.tscn")
const X = preload("res://nodes/x.tscn")
const Y = preload("res://nodes/y.tscn")
const Z = preload("res://nodes/z.tscn")

var letter_scenes = {
	KEY_A: A,
	KEY_B: B,
	KEY_C: C,
	KEY_D: D,
	KEY_E: E,
	KEY_F: F,
	KEY_G: G,
	KEY_H: H,
	KEY_I: I,
	KEY_J: J,
	KEY_K: K,
	KEY_L: L,
	KEY_M: M,
	KEY_N: N,
	KEY_O: O,
	KEY_P: P,
	KEY_Q: Q,
	KEY_R: R,
	KEY_S: S,
	KEY_T: T,
	KEY_U: U,
	KEY_V: V,
	KEY_W: W,
	KEY_X: X,
	KEY_Y: Y,
	KEY_Z: Z
}

func _ready() -> void:
	pass # Replace with function body.

# Adding number of booster
func Add_Booster(type: int) -> void:
	if type == 1:
		Booster_1_Count += 1
		print("Booster1: ", Booster_1_Count)
	elif type == 2:
		Booster_2_Count += 1
		print("Booster1: ", Booster_2_Count)
	elif type == 3:
		Booster_3_Count += 1
		print("Booster1: ", Booster_3_Count)

func Minus_Booster(type: int) -> void:
	if type == 1:
		Booster_1_Count -= 1
		if Booster_1_Count <= 0:
			Booster_1_Count = 0
	elif type == 2:
		Booster_2_Count -= 1
		if Booster_2_Count <= 0:
			Booster_2_Count = 0
	elif type == 3:
		Booster_3_Count -= 1
		if Booster_3_Count <= 0:
			Booster_3_Count = 0

func Add_Health() -> void:
	Health_Points += 10
	if Health_Points > 100:
		Health_Points = 100
func Minus_Health(point: int) -> void:
	Health_Points -= point
	if Health_Points <= 0:
		pass   # this one should die
		
		
func get_random_word(length: int) -> String:
	return word_pool[length].pick_random()
