module DataMapper::Mongo::Spec
  module ProcessHelper
    def spawn(arguments)
      if Process.respond_to? :spawn
        Process.spawn *arguments
      else
        if arguments.last.kind_of? Hash
          opts = arguments.pop
        end
        fork do |child,pid|
          p arguments
          Kernel.exec *arguments
        end
      end
    end
  end
end
