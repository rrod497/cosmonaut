class_name Asteroid
extends Area2D

enum Size {S, M, L, XL}

signal destroyed
signal partitioned(debris)

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
@onready var _knockback = 0

func _process(delta):
  if hits >= _max_hits:
    destroy()
  else:
    if _knockback:
      _knockback = lerp(_knockback, 0.0 , 0.1)
    translate(direction * (delta * _speed) - Vector2(0, _knockback))
    rotate(_spin * delta)

func damage():
  hits += 1
  if hits < _max_hits:
    $anime.play("damage")
    _spin = randf_range(-prefs.max_spin, prefs.max_spin)
    direction = Vector2(randf_range(-0.25, 0.25), 1)
  else:
    drop_loot()
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
  if asteroids.is_empty():
    return
  for n in debris:
    var asteroid = asteroids.pick_random().instantiate()
    call_deferred("add_sibling", asteroid)
    asteroid.position = position
    asteroid.rotation = rotation
    asteroid.direction = Vector2(randf_range(-1, 1), 1).normalized()
  partitioned.emit(debris)

func drop_loot():
  var loot = settings.get_loot(prefs.max_loot)
  for item in loot:
    var collectible = item.instantiate()
    call_deferred("add_sibling", collectible)
    collectible.position = position

func _on_body_entered(body):
  if body.is_in_group("player"):
    (body as Player).damage(_damage)
  destroy()

func _on_area_entered(area):
  if area.is_in_group("player_fire"):
    _knockback += prefs.knockback
    damage()
  elif area.is_in_group("shield"):
    _knockback += prefs.knockback
    game_state.player.remove_shield()
    damage()
