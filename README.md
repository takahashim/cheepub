# Cheepub

[![Gem Version](https://badge.fury.io/rb/cheepub.svg)](https://badge.fury.io/rb/cheepub) [![Build Status](https://travis-ci.org/takahashim/cheepub.svg?branch=master)](https://travis-ci.org/takahashim/cheepub) [![Maintainability](https://api.codeclimate.com/v1/badges/15d5db3048b9067703a6/maintainability)](https://codeclimate.com/github/takahashim/cheepub/maintainability) [![Dependency Status](https://gemnasium.com/badges/github.com/takahashim/cheepub.svg)](https://gemnasium.com/github.com/takahashim/cheepub)


Cheepub is EPUB generator from Markdown.  When you have markdown file, you can generate EPUB3 file with just one command: `cheepub sample.md`.

## Installation

You can install just use `gem` command:

    $ gem install cheepub

If you use the gem in your project, add this line to your application's Gemfile:

```ruby
gem 'cheepub'
```

## Usage

You can add options `--title` and `--author`.

```sh
$ cheepub --title foo --author bar source.md
```

If you use front-matter section like Jekyll, you can execute without any options:

```sh
$ cheepub source.md
```

### Options

* `-v, --version`                 print version
* `--author AUTOR`                set author of the book
* `--title TITLE`                 set title of the book
* `--config CONFIG`               set configuration file
* `-o, --out EPUBFILE`            set output epub filename
* `-h, --help`                    print help


## Markdown extensions

Cheepub uses [Kramdown](https://github.com/gettalong/kramdown) and [Gepub](https://github.com/skoji/gepub).
So you can use Kramdown extensions and some other extensions from [DenDenMarkdown](https://github.com/denshoch/DenDenMarkdown).

* newpage (separate files): ex. `===` or `------`.
* tate-chu-yoko (horizontal in vertical): ex. `^30^` or `!?`.
* footnote: ex. `[^1]` and `[^1]: some notes about it`.
* ruby: ex. `{some base text|some ruby text}`


## Configuration

You can define configration with in front-matter or `--config` option.

### Configuration items

* id: identifier
* title: title of the book
* author: author of the book
* date: publishing date
* lastModified: last modified date-time
* pageDirection: `ltr` or `rtl`

## History

### 0.4.0

- fix writing-mode (pageDirection)
- fix to generate nav.xhtml

### 0.3.0

- add option `--out`

### 0.2.0

- add option `--title`, `--author`, `--config`

### 0.1.0

- First release.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takahashim/cheepub.
