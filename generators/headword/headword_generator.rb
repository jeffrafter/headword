
# Mostly pinched from http://github.com/ryanb/nifty-generators/tree/master
Rails::Generator::Commands::Create.class_eval do
  def insert_into(file, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend] || File.read(destination_path(file)).include?(line)
      gsub_file file, /^(class|module) .+$/ do |match|
        "#{match}\n  #{line}"
      end
    end
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def insert_into(file, line)
    logger.remove "#{line} from #{file}"
    unless options[:pretend]
      gsub_file file, "\n  #{line}", ''
    end
  end
end

class HeadwordGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      model = "app/models/user.rb"

      if File.exists?(model)
        m.insert_into model, "include Headword::User"
      else
        m.directory File.join("app", "models")
        m.file "user.rb", model
      end

      m.directory File.join("app", "views", "users")
      m.file "show.html.erb", "app/views/users/show.html.erb"

      m.directory File.join("test", "factories")
      m.file "factories.rb", "test/factories/headword.rb"      

      m.migration_template "migrations/#{migration_name}.rb", 'db/migrate', 
        :migration_file_name => "headword_#{migration_name}"

      m.readme "README"
    end
  end

  private

  def migration_name
    if ActiveRecord::Base.connection.table_exists?(:users)
      'update_users'
    else
      'create_users'
    end
  end
end