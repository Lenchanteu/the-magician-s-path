extends CharacterBody2D

const SPEED := 3000
var direction := 1.0

var frozen := false
var freeze_timer := 0.0

func _physics_process(delta: float) -> void:
	if frozen:
		velocity = Vector2.ZERO
		freeze_timer -= delta

		if freeze_timer <= 0:
			unfreeze()
	else:
		velocity.x = SPEED * direction

	move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)

		if abs(collision.get_normal().x) > 0.5:
			direction *= -1.0
			break


func freeze(duration: float) -> void:
	frozen = true
	freeze_timer = duration
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)

func unfreeze() -> void:
	frozen = false
