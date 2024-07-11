# Capistrano::Teller

## Installation

```
bundle add capistrano-teller
```

**Add .teller.yml**
```
providers:
  aws_secretsmanager:
    kind: aws_secretsmanager
    maps:
      - id: aws
        path: {{ get_env(name="RAILS_ENV", default="development") }}/{{get_env(name="NORMALIZED_REPO", default='application')}}/environment
  dotenv:
    kind: dotenv
    maps:
      - id: 'dotenv'
        path: .env.{{ get_env(name="RAILS_ENV", default="development") }}
```



## Usage

deploy.rb
```
set :rails_env, -> { fetch(:stage) }

set :teller_config, -> { File.join(Dir.pwd, '.teller.yml')}
set :teller_environment, -> { fetch(:rails_env) }
set :teller_source_provider, 'aws_secretsmanager/aws'
set :teller_target_provider, 'dotenv/dotenv'
set :teller_identifier, -> { fetch(:application) }

server 'i-404004040b', roles: [:whenever, :app, :web, :teller]
```

```
cap staging deploy
```

Will generate `.env.#{:rails_env}` locally and copy it to the `shared_path` and link to the `current_release`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-teller.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
