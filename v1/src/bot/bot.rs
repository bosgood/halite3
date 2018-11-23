use hlt::command::Command;
use hlt::direction::Direction;
use hlt::game::Game;
use hlt::navi::Navi;
use rand::prng::XorShiftRng;
use rand::Rng;

pub struct Bot {
  rng: XorShiftRng,
}

impl Bot {
  pub fn new(rng: XorShiftRng) -> Self {
    Bot { rng: rng }
  }

  pub fn advance(&self) -> Self {
    Bot {
      rng: self.rng.clone(),
    }
  }

  pub fn play_turn(&mut self, game: &Game, navi: &Navi) -> Vec<Command> {
    let me = &game.players[game.my_id.0];
    let mut command_queue: Vec<Command> = Vec::new();

    for ship_id in &me.ship_ids {
      let ship = &game.ships[ship_id];
      let cell = game.map.at_entity(ship);

      let command = if cell.halite < game.constants.max_halite / 10 || ship.is_full() {
        let random_direction = Direction::get_all_cardinals()[self.rng.gen_range(0, 4)];
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
