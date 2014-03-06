class MongoDatabaseCleaner
  def self.clean
    root = File.expand_path(File.dirname(__FILE__) + '/../../..')
    
    Dir["#{root}/app/models/**/*.*"].each do |name|
      path_name = name.gsub("#{root}/app/models/", '')
      path_name = path_name.split('/')
      
      next if path_name.try(:first) == 'concerns'
      
      klass = path_name.pop.sub(/\.rb$/,'').camelize
      
      unless path_name.none?
        klass = [path_name.map(&:camelize).join('::'), klass].join('::')
      end
      
      begin
        klass = klass.constantize
      rescue Exception => e
        raise e
        raise [klass, root, name, path_name].inspect
      end
      
      next if klass.respond_to?(:table_name) || !klass.respond_to?(:delete_all)
      
      klass.delete_all
    end
  end
end