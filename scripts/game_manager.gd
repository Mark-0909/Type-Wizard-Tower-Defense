extends Node

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

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_random_word(length: int) -> String:
	return word_pool[length].pick_random()
