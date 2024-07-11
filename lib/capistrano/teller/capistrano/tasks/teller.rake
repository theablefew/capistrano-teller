
namespace :teller do

  def teller(*args)
    puts "Executing: #{fetch(:teller_command)}"
    execute fetch(:teller_command), *args
  end

  desc "Copy the .env.environment to the server"
  task :copy do
      run_locally do
        with rails_env: fetch(:teller_environment) do
          execute :touch, ".env.#{fetch(:teller_environment)}"
          teller "--config #{fetch(:teller_config)}", :copy, "--from #{fetch(:teller_source_provider)}", "--to #{fetch(:teller_target_provider)}"
        end
      end
  end

  task :upload_environment_file do
    on roles(:teller) do
      puts "Uploading .env.#{fetch(:teller_environment)} to #{fetch(:teller_shared_path)}/config/teller.yml"
      upload! ".env.#{fetch(:teller_environment)}", "#{fetch(:teller_shared_path)}/config/teller.yml"
    end

    puts "#{fetch(:linked_files)}"

    run_locally do
      execute :rm, ".env.#{fetch(:teller_environment)}"
    end
  end

end

before "deploy:symlink:linked_files", "teller:copy"
after "teller:copy", "teller:upload_environment_file"

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
    append :linked_files, ".env.#{fetch(:teller_environment)}"
  end
end


