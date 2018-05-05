# Cheepub

[![Gem Version](https://badge.fury.io/rb/cheepub.svg)](https://badge.fury.io/rb/cheepub)[![Build Status](https://travis-ci.org/takahashim/cheepub.svg?branch=master)](https://travis-ci.org/takahashim/cheepub)

Cheepub is EPUB generator from Markdown.  When you have markdown file, you can generate EPUB3 file with just one command: `cheepub sample.md`.

## Installation

You can install just use `gem` command:

    $ gem install cheepub

If you use the gem in your project, add this line to your application's Gemfile:

```ruby
gem 'cheepub'
```

And then execute:

    $ bundle

## Usage

You can add options `--title` and `--author`.

```sh
$ cheepub --title foo --author bar source.md
```

If you use front-matter section like Jekyll, you can execute without any options:

```sh
$ cheepub source.md
```

## Markdown extensions

Cheepub uses [Kramdown](https://github.com/gettalong/kramdown) and [Gepub](https://github.com/skoji/gepub).
So you can use Kramdown extensions and some other extensions from [DenDenMarkdown](https://github.com/denshoch/DenDenMarkdown).


## History

### 0.2.0

- add option `--title`, `--author`, `--config`

### 0.1.0

- First release.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takahashim/cheepub.
