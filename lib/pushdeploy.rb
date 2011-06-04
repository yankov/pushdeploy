class PushDeploy      

    EMPTY_DIR = '4b825dc642cb6eb9a060e54bf8d69288fbee4904'
      
    def initialize(args, &block)       

      puts 'Running after_deploy...'
      puts "!!!"
      puts args                                                           
      
      @deploy_to, @oldrev, @newrev = args.shift, args.shift, args.shift || 'HEAD'          
      puts "deploy !! #{@deploy_to}"
      if @oldrev == '0000000000000000000000000000000000000000'
        @oldrev = EMPTY_DIR
      elsif @oldrev.nil?
        @oldrev = '@{-1}'
      end    
      
      instance_exec(&block)
                                
    end
                                
    def bundle
      return if @oldrev == '0'

      return unless File.exist?('Gemfile')
      if %x{git diff --name-only #{@oldrev} #{@newrev}} =~ /^Gemfile|\.gemspec$/
        begin
          # If Bundler in turn spawns Git, it can get confused by $GIT_DIR
          git_dir = ENV.delete('GIT_DIR')
          run "bundle check"
          unless $?.success?
            puts "Bundling..."
            run "bundle | grep -v '^Using ' | grep -v ' is complete'"
          end
        ensure
          ENV['GIT_DIR'] = git_dir
        end
      end
    end  
    
    def run(command)
      Kernel.system "#{command} >&1"
    end     
    
    def migrate
      return if @oldrev == '0'  
      
      schema = %x{git diff --name-status #{@oldrev} #{@newrev} -- db/schema.rb}
      if schema =~ /^A/
        run "bundle exec rake db:create"
      end 
      
      if `git diff HEAD^`.index("db/migrate")
       puts "Migrating.."
       run 'bundle exec rake db:migrate RAILS_ENV="production"'
      end
    end
end