This is a collection of tools for maintaining a repository of halite3 bots to
help you iterate and improve your strategy in the tournament.

This repository is structured around storing every intermediate version of your
bots so that you can play new strategies against old ones to verify if your new
strategy is stronger prior to submitting a new version.

The only things you need installed are `rustup` to manage the Rust toolchain and `pipenv` to manage your python virtual environment for the halite client tools.

Installing rustup, per the [rustup](https://rustup.rs/) instructions:

```
curl https://sh.rustup.rs -sSf | sh
```

Installing pipenv:

```
brew install pipenv
```


Now you're ready to bootstrap the dependencies needed for the halite client tools with:

```
make bootstrap
```

The halite client isn't necessary to play halite so if the above breaks for some
reason, don't worry! You can still follow along in the process below for testing
that your account is in working order and that you can upload new Rust bots!


### Playing Halite

You should now be ready to upload your first bot and see how it performs!

We're going to go through submitting the standard `sample_bot` available as the
sample kit for Rust.

First register for an account on [halite.io](https://halite.io/).

This repository is structured to keep each bot implementation in its own folder
as separate crate projects. When you submit your bot to halite, it must be
packaged as a self-contained zip file that crate can build on its own.

To build the `sample_bot` run:

```
make build
```

This will build every bot you've written in this repo.

Now let's upload our bot to see how it does in the tournament.  This make
command will clear out the build artifacts to save space, package your bot in a
zip file, and open Chrome for uploading the zip file.  Run it:

```
BOT=sample_bot make upload
```

And drag the zip file into the box to upload your submission.

![Drag to upload](/docs/images/upload.drag.png)

After uploading your bot, you can go to [your
profile](https://halite.io/user?me) and after a few minutes you will see the
results of the matches that it plays.
