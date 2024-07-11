
namespace :teller do

  def teller(*args)
    execute fetch(:teller_command), *args
  end

  desc "Copy the .env.environment to the server"
  task :copy do
      run_locally do
        with(rails_env: fetch(:teller_environment), normalized_repo: fetch(:teller_identifier) )do
          execute :touch, fetch(:teller_environment_file)
          teller "--config #{fetch(:teller_config)}", :copy, "--from #{fetch(:teller_source_provider)}", "--to #{fetch(:teller_target_provider)}"
        end
      end
  end

  task :upload_environment_file do
    on roles(:teller) do
      upload! fetch(:teller_environment_file), "#{fetch(:teller_shared_path)}/#{fetch(:teller_environment_file)}"
    end
  end

  task :remove_environment_file do
    run_locally do
      execute :rm, fetch(:teller_environment_file)
    end
  end

end

before "deploy:check:linked_files", "teller:copy"
after "teller:copy", "teller:upload_environment_file"
after "deploy:cleanup", "teller:remove_environment_file"

namespace :load do
  task :defaults do
    set :teller_roles,            ->{ [:teller] }
    set :teller_config,           ->{ ".teller.yml" }
    set :teller_source_provider,  ->{ :aws_secretsmanager }
    set :teller_command_path,     ->{ `which teller` }
    set :teller_target_provider,  ->{ :dotenv }
    set :teller_stage,            ->{ fetch(:rails_env, :development) }
    set :teller_command,          ->{ fetch(:teller_command_path).chomp }
    set :teller_environment,      ->{ fetch :rails_env, fetch(:stage, "production") }
    set :teller_shared_path,      ->{ fetch(:shared_path) }
    set :teller_identifier,       ->{ fetch(:application) }
    set :teller_environment_file, ->{ ".env.#{fetch(:teller_environment)}" }
    append :linked_files, ".env.#{fetch(:teller_environment)}"
  end
end


