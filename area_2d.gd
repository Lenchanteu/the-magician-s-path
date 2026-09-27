extends Area2D

@export var destination: Node2D

var player_inside: CharacterBody2D = null

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null

func _process(_delta: float) -> void:
	if player_inside != null and Input.is_action_just_pressed("teleport"):
		teleport()

func teleport() -> void:
	if destination == null:
		return

	player_inside.global_position = destination.global_position
	player_inside.velocity = Vector2.ZERO
