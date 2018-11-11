use hlt::command::Command;
use hlt::direction::Direction;
use hlt::game::Game;

pub struct Bot {}

impl Bot {
  pub fn new() -> Bot {
    Bot {}
  }

  pub fn play_turn(&mut self, game: Game) -> Vec<Command> {
    let me = &game.players[game.my_id.0];
    let map = &mut game.map;

    let mut command_queue: Vec<Command> = Vec::new();

    for ship_id in &me.ship_ids {
      let ship = &game.ships[ship_id];
      let cell = map.at_entity(ship);

      let command = if cell.halite < game.constants.max_halite / 10 || ship.is_full() {
        let random_direction = Direction::get_all_cardinals()[rng.gen_range(0, 4)];
        ship.move_ship(random_direction)
      } else {
        ship.stay_still()
      };
      command_queue.push(command);
    }

    if game.turn_number <= 200
      && me.halite >= game.constants.ship_cost
      && navi.is_safe(&me.shipyard.position)
    {
      command_queue.push(me.shipyard.spawn());
    }

    return command_queue;
  }
}
