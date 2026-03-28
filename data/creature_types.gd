# Creature Type system - defines type relationships and effectiveness
extends Resource
class_name CreatureType

enum TYPE {
	NORMAL = 0,
	FIRE = 1,
	WATER = 2,
	GRASS = 3,
	ELECTRIC = 4,
	ICE = 5,
	FIGHTING = 6,
	POISON = 7,
	GROUND = 8,
	FLYING = 9,
	PSYCHIC = 10,
	BUG = 11,
	ROCK = 12,
	GHOST = 13,
	DRAGON = 14,
	DARK = 15,
	STEEL = 16,
	FAIRY = 17,
}

# Type effectiveness chart (attacker -> defender -> multiplier)
static var type_effectiveness = {
	TYPE.NORMAL: {TYPE.ROCK: 0.5, TYPE.GHOST: 0.0, TYPE.STEEL: 0.5},
	TYPE.FIRE: {TYPE.FIRE: 0.5, TYPE.WATER: 0.5, TYPE.GRASS: 2.0, TYPE.ICE: 2.0, TYPE.BUG: 2.0, TYPE.STEEL: 2.0, TYPE.ROCK: 0.5, TYPE.DRAGON: 0.5},
	TYPE.WATER: {TYPE.FIRE: 2.0, TYPE.WATER: 0.5, TYPE.GRASS: 0.5, TYPE.GROUND: 2.0, TYPE.ROCK: 2.0, TYPE.DRAGON: 0.5},
	TYPE.GRASS: {TYPE.FIRE: 0.5, TYPE.WATER: 2.0, TYPE.GRASS: 0.5, TYPE.POISON: 0.5, TYPE.GROUND: 2.0, TYPE.ROCK: 2.0, TYPE.DRAGON: 0.5},
	TYPE.ELECTRIC: {TYPE.WATER: 2.0, TYPE.GRASS: 0.5, TYPE.ELECTRIC: 0.5, TYPE.GROUND: 0.0, TYPE.FLYING: 2.0, TYPE.DRAGON: 0.5},
	TYPE.ICE: {TYPE.FIRE: 0.5, TYPE.WATER: 0.5, TYPE.GRASS: 2.0, TYPE.ICE: 0.5, TYPE.GROUND: 2.0, TYPE.FLYING: 2.0, TYPE.DRAGON: 2.0},
	TYPE.FIGHTING: {TYPE.NORMAL: 2.0, TYPE.ICE: 2.0, TYPE.ROCK: 2.0, TYPE.DARK: 2.0, TYPE.STEEL: 2.0, TYPE.FLYING: 0.5, TYPE.PSYCHIC: 0.5, TYPE.FAIRY: 0.5},
	TYPE.POISON: {TYPE.GRASS: 2.0, TYPE.POISON: 0.5, TYPE.GROUND: 0.5, TYPE.ROCK: 0.5, TYPE.GHOST: 0.5, TYPE.STEEL: 0.0, TYPE.FAIRY: 2.0},
	TYPE.GROUND: {TYPE.FIRE: 2.0, TYPE.ELECTRIC: 2.0, TYPE.POISON: 2.0, TYPE.ROCK: 2.0, TYPE.STEEL: 2.0, TYPE.GRASS: 0.5, TYPE.FLYING: 0.0},
	TYPE.FLYING: {TYPE.FIGHTING: 2.0, TYPE.BUG: 2.0, TYPE.GRASS: 2.0, TYPE.ELECTRIC: 0.5, TYPE.ROCK: 0.5, TYPE.STEEL: 0.5},
	TYPE.PSYCHIC: {TYPE.FIGHTING: 2.0, TYPE.POISON: 2.0, TYPE.PSYCHIC: 0.5, TYPE.DARK: 0.0, TYPE.STEEL: 0.5},
	TYPE.BUG: {TYPE.FIRE: 0.5, TYPE.GRASS: 2.0, TYPE.FIGHTING: 0.5, TYPE.POISON: 0.5, TYPE.FLYING: 0.5, TYPE.PSYCHIC: 2.0, TYPE.GHOST: 0.5, TYPE.DARK: 2.0, TYPE.STEEL: 0.5, TYPE.FAIRY: 0.5},
	TYPE.ROCK: {TYPE.FIRE: 2.0, TYPE.ICE: 2.0, TYPE.FLYING: 2.0, TYPE.BUG: 2.0, TYPE.FIGHTING: 0.5, TYPE.GROUND: 0.5, TYPE.STEEL: 0.5},
	TYPE.GHOST: {TYPE.NORMAL: 0.0, TYPE.PSYCHIC: 2.0, TYPE.GHOST: 2.0, TYPE.DARK: 0.5},
	TYPE.DRAGON: {TYPE.DRAGON: 2.0, TYPE.STEEL: 0.5, TYPE.FAIRY: 0.0},
	TYPE.DARK: {TYPE.FIGHTING: 0.5, TYPE.PSYCHIC: 2.0, TYPE.GHOST: 2.0, TYPE.DARK: 0.5, TYPE.FAIRY: 0.5},
	TYPE.STEEL: {TYPE.FIRE: 0.5, TYPE.WATER: 0.5, TYPE.GRASS: 0.5, TYPE.ICE: 2.0, TYPE.ROCK: 2.0, TYPE.FAIRY: 2.0, TYPE.NORMAL: 2.0, TYPE.FLYING: 2.0, TYPE.PSYCHIC: 0.5, TYPE.BUG: 0.5, TYPE.GHOST: 0.5, TYPE.STEEL: 0.5, TYPE.DRAGON: 0.5, TYPE.POISON: 0.0},
	TYPE.FAIRY: {TYPE.FIGHTING: 2.0, TYPE.POISON: 0.5, TYPE.DARK: 2.0, TYPE.FIRE: 0.5, TYPE.STEEL: 0.5},
}

static var type_names = {
	TYPE.NORMAL: "Normal",
	TYPE.FIRE: "Fire",
	TYPE.WATER: "Water",
	TYPE.GRASS: "Grass",
	TYPE.ELECTRIC: "Electric",
	TYPE.ICE: "Ice",
	TYPE.FIGHTING: "Fighting",
	TYPE.POISON: "Poison",
	TYPE.GROUND: "Ground",
	TYPE.FLYING: "Flying",
	TYPE.PSYCHIC: "Psychic",
	TYPE.BUG: "Bug",
	TYPE.ROCK: "Rock",
	TYPE.GHOST: "Ghost",
	TYPE.DRAGON: "Dragon",
	TYPE.DARK: "Dark",
	TYPE.STEEL: "Steel",
	TYPE.FAIRY: "Fairy",
}

static var type_colors = {
	TYPE.NORMAL: Color(0.8, 0.8, 0.8),
	TYPE.FIRE: Color(1.0, 0.5, 0.0),
	TYPE.WATER: Color(0.3, 0.6, 1.0),
	TYPE.GRASS: Color(0.4, 0.8, 0.4),
	TYPE.ELECTRIC: Color(1.0, 1.0, 0.2),
	TYPE.ICE: Color(0.5, 0.9, 1.0),
	TYPE.FIGHTING: Color(0.8, 0.4, 0.2),
	TYPE.POISON: Color(0.8, 0.3, 0.8),
	TYPE.GROUND: Color(0.9, 0.8, 0.5),
	TYPE.FLYING: Color(0.7, 0.7, 1.0),
	TYPE.PSYCHIC: Color(1.0, 0.5, 0.8),
	TYPE.BUG: Color(0.6, 0.8, 0.2),
	TYPE.ROCK: Color(0.8, 0.7, 0.5),
	TYPE.GHOST: Color(0.6, 0.5, 0.8),
	TYPE.DRAGON: Color(0.7, 0.5, 1.0),
	TYPE.DARK: Color(0.5, 0.4, 0.6),
	TYPE.STEEL: Color(0.7, 0.7, 0.8),
	TYPE.FAIRY: Color(1.0, 0.6, 0.9),
}

static func get_type_effectiveness(attacker_type: int, defender_type: int) -> float:
	if attacker_type in type_effectiveness:
		if defender_type in type_effectiveness[attacker_type]:
			return type_effectiveness[attacker_type][defender_type]
	return 1.0

static func get_type_name(type: int) -> String:
	return type_names.get(type, "Unknown")

static func get_type_color(type: int) -> Color:
	return type_colors.get(type, Color.WHITE)
