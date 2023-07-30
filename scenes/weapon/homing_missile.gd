extends Area2D

@export var prefs : ProjectilePrefs
@onready var damage = prefs.damage
@onready var _speed = prefs.speed
var _dir = Vector2(0,-1)
var target = null

func start(pos, dir):
  global_position = pos
  _dir = dir.normalized()
#  position = pos
  $spawn.emitting = true
  target = weakref(select_target())

func _physics_process(delta):
  if target.get_ref():
    _dir = _dir.lerp(position.direction_to(target.get_ref().position), delta * 10).normalized()
  translate(delta * _dir * _speed)
  rotate(get_angle_to(global_position + _dir)+ PI/2)


func _on_visible_screen_exited():
  queue_free()

func _on_area_entered(area):
  destroy()

func destroy():
  _speed = 0
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $explosion.emitting = true
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()

func select_target():
  var foes = get_tree().get_nodes_in_group("asteroids")
  foes.filter(func (a): a.isDestroyed == false)
  if !foes.is_empty():
    foes.sort_custom(func (a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
    return foes[0]
