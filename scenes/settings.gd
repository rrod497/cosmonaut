extends Node

@export var asteroids_S: Array[PackedScene]
@export var asteroids_M: Array[PackedScene]
@export var asteroids_L: Array[PackedScene]
@export var asteroids_XL: Array[PackedScene]
@export var loot: Array[PackedScene]

@onready var _ast_dict = {
  Asteroid.Size.S: asteroids_S,
  Asteroid.Size.M: asteroids_M,
  Asteroid.Size.L: asteroids_L,
  Asteroid.Size.XL: asteroids_XL,
}

func _ready():
  pass
#  for a in asteroids:
#    _ast_dict[a.size].add(a)
#@export var asteroid_size_settings

func get_asteroids(size = null):
  var res = []
  for s in _ast_dict:
    if size == null or s < size:
      res += _ast_dict[s]
  return res
