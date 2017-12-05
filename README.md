# Codebreaker

This is an implementation of [Bulls and Cows game](https://en.wikipedia.org/wiki/Bulls_and_Cows).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codebreaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install codebreaker

## Usage

Create an instance of the game:

```ruby
game = Codebreacker::Game.new
```

During instantiation you can set matcher (object that will be used for guesses matching) and storage (object that will be used for storing scores).

### Matcher

`Codebreaker::Matcher` object uses marker object to prepare the result of the matching. Now there are two variants of markers available: `Codebreaker::Markers::PlusMinusMarker` and `Codebreaker::Markers::ClassicalMarker`.

By default, `Codebreaker::Markers::PlusMinusMarker` will be used.

### Storages

There are two variants of storages implemented: `Codebreaker::Storage::InMemoryStorage` and `Codebreaker::Storage::CsvStorage`.

By default, the `Codebreaker::Storage::InMemoryStorage` will be used, as the it doesn't require any supplumental parameters. Be aware, that this kind of storage mostly used as fall back object, and all contents will be lost after programm will stop running.

After the game is initialized it should be started:

```ruby
game.start
```

The program can interact with the game using following calls:

- ```game.guess('1234')``` - make a guess. Will return ```true``` if guess was correct and ```false``` otherwise.
- ```game.attempts_available?```
- ```game.marks``` - will return the result of the matching.
- ```game.hint```
- ```game.won?```
- ```game.lost?```
- ```game.in_progress?```
- ```game.save(name)``` - saves the current game score.
- ```game.scores``` - return an array of scores from the storage.

After the game is over you can restart it calling ```game.start``` again.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/codebreaker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
