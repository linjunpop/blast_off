# BlastOff

An iOS beta distribution tool.

Supported services:

* Qiniu(http://qiniu.com)

## Installation

Add this line to your application's Gemfile:

    gem 'blast_off'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blast_off

## Usage

```
NAME
    blast_off - An iOS beta distribution tool.

SYNOPSIS
    blast_off [global options] command [command options] [arguments...]

VERSION
    0.0.1

GLOBAL OPTIONS
    --help    - Show this message
    --version - Display the program version

COMMANDS
    help  - Shows a list of commands or help for one command
    qiniu - Qiniu
```

## Services

### Qiniu

```
NAME
    qiniu - Qiniu

SYNOPSIS
    blast_off [global options] qiniu [command options]

COMMAND OPTIONS
    --access_key=arg    - Access Key (default: none)
    --bucket=arg        - bucket (default: none)
    --ipa_file_path=arg - IPA file path (default: none)
    --secret_key=arg    - Secret Key (default: none)
```

Example:

`$ blast_off qiniu --ipa_file_path=Foobar.ipa --bucket=foobar --access_key=$QINIU_ACCESS_KEY --secret_key=$QINIU_SECRET_KEY`

## Changelog

https://github.com/linjunpop/blast_off/wiki/Changelog

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/linjunpop/blast_off/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

