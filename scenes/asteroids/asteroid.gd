class_name Asteroid
extends Area2D

enum Size {S, M, L, XL}

signal destroyed

@export var prefs : AsteroidPrefs
@export var size = Size.S
@export var direction = Vector2.DOWN
@export var hits = 0

@onready var _speed = randi_range(prefs.min_speed, prefs.max_speed)
@onready var _spin = randf_range(-prefs.max_spin, prefs.max_spin)
@onready var _max_hits = prefs.max_hits
@onready var _scale = prefs.scale
@onready var _damage = prefs.damage
@onready var _debris = randi_range(prefs.min_debris, prefs.max_debris)

func _process(delta):
  if hits >= _max_hits:
    destroy()
  else:
    rotate(_spin * delta)
    translate(direction * (delta * _speed))

func _on_area_entered(area):
  damage()

func damage():
  hits += 1
  if hits < _max_hits:
    $anime.play("damage")
    _spin = randf_range(-prefs.max_spin, prefs.max_spin)
  else:
    destroy()
    partition(_debris)

func destroy():
  destroyed.emit()
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()

func partition(debris):
  var asteroids = settings.get_asteroids(size)
#  var asteroids = settings.asteroids
#  var asteroids = settings.asteroids.filter(func(a): return a.resource < size)
  if asteroids.is_empty():
    return
  for n in debris:
    var asteroid = asteroids.pick_random().instantiate()
    call_deferred("add_sibling", asteroid)
#    get_parent().call_deferred("add_child", a)
    asteroid.position = position
    asteroid.rotation = rotation
    asteroid.direction = Vector2(randf_range(-1, 1), 1).normalized()
