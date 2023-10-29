extends Node

#GameManager
signal new_game_started
signal level_over
signal game_over_hit
signal respawn
signal restart_game
signal start_next_level
signal score_changed(new_score : String)
signal lives_changed(new_lives : String)

#SceneManager
signal spawn_player()
signal spawn_init_asteroids()

#Asteroid
signal pebble_spawn(new_pebble : Asteroid)
signal asteroid_destroyed(destroyed_asteroid: Asteroid)

#PlayerShip
signal ship_destroyed

#AsteroidManager
signal all_destroyed
signal add_score(points : int)

#PlayerManager
signal player1_spawned(player : PlayerShip)