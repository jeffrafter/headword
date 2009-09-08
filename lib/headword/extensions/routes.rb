if defined?(ActionController::Routing::RouteSet)
  class ActionController::Routing::RouteSet
    def load_routes_with_headword!
      lib_path = File.dirname(__FILE__)
      routes = File.join(lib_path, *%w[.. .. .. config headword_routes.rb])
      unless configuration_files.include?(routes)
        add_configuration_file(routes)
      end
      load_routes_without_headword!
    end

    alias_method_chain :load_routes!, :headword
  end
end