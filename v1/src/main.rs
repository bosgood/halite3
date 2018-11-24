#[macro_use]
extern crate lazy_static;
extern crate rand;

use bot::bot::Bot;
use hlt::game::Game;
use hlt::log::Log;
use hlt::navi::Navi;
use rand::prng::XorShiftRng;
use rand::SeedableRng;
use std::env;
use std::time::SystemTime;
use std::time::UNIX_EPOCH;

mod bot;
mod hlt;

fn main() {
  let args: Vec<String> = env::args().collect();
  let rng_seed: u64 = if args.len() > 1 {
    args[1].parse().unwrap()
  } else {
    SystemTime::now()
      .duration_since(UNIX_EPOCH)
      .unwrap()
      .as_secs()
  };
  let seed_bytes: Vec<u8> = (0..16)
    .map(|x| ((rng_seed >> (x % 8)) & 0xFF) as u8)
    .collect();
  let rng: XorShiftRng = SeedableRng::from_seed([
    seed_bytes[0],
    seed_bytes[1],
    seed_bytes[2],
    seed_bytes[3],
    seed_bytes[4],
    seed_bytes[5],
    seed_bytes[6],
    seed_bytes[7],
    seed_bytes[8],
    seed_bytes[9],
    seed_bytes[10],
    seed_bytes[11],
    seed_bytes[12],
    seed_bytes[13],
    seed_bytes[14],
    seed_bytes[15],
  ]);

  let mut game = Game::new();
  let mut navi = Navi::new(game.map.width, game.map.height);
  // At this point "game" variable is populated with initial map data.
  // This is a good place to do computationally expensive start-up pre-processing.
  // As soon as you call "ready" function below, the 2 second per turn timer will start.
  Game::ready("v1");

  Log::log(&format!(
    "Successfully created bot! My Player ID is {}. Bot rng seed is {}.",
    game.my_id.0, rng_seed
  ));

  let mut bot = Bot::new(rng);
  loop {
    game.update_frame();
    navi.update_frame(&game);

    bot = bot.advance();
    let command_queue = bot.play_turn(&game, &navi);
    Game::end_turn(&command_queue);
  }
}
