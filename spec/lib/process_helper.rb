module DataMapper::Mongo::Spec
  module ProcessHelper
    def process_fd(fd,value)
      case value
      when Array
        fd.reopen File.open *value
      when IO
        fd.reopen value
      when '/dev/null'
        fd.reopen File.open value
      end
    end

    def spawn(arguments)
      if Process.respond_to? :spawn
        Process.spawn *arguments
      else
        if arguments.last.kind_of? Hash
          opts = arguments.pop
        end
        fork do |child,pid|
          opts.each do |key,value|
            case key
            when :out
              process_fd($stdout,value)
            when :err
              process_fd($stderr,value)
            end
          end if opts
          Kernel.exec *arguments
        end
      end
    end
  end
end
