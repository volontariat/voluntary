class MongoDatabaseCleaner
  def self.clean
    root = File.expand_path(File.dirname(__FILE__) + '/../../..')
    
    Dir["#{root}/app/models/**/*.*"].each do |path_name|
      path_name.gsub!("#{root}/app/models/", '')
      path_name = path_name.split('/')
      klass = path_name.pop.sub(/\.rb$/,'').camelize
      
      unless path_name.none?
        klass = [path_name.map(&:camelize).join('::'), klass].join('::')
      end
      
      begin
        klass = klass.constantize
      rescue
        raise path_name
      end
      
      next if klass.respond_to?(:table_name) || !klass.respond_to?(:delete_all)
      
      klass.delete_all
    end
  end
end