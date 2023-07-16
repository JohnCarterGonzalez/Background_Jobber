require_relative 'child'

module BackgroundJobber
  class Parent
    def spawn_child_loop(loop_count)
      @threads = []

      # this burner child exists only for testing purpose
      # without it child process id's are blank
      child_process_id = fork do
        p "burner child pid #{child_process_id}"
      end

      # spawn child processes
      loop_count.times do
          child_process_id = fork do
          begin
            # create a new child obj, and spawn a worker thread
            child = Child.new
            p "child pid #{child_process_id}"
            #  there may be a better way to join threads but this is what
            #  I came up with
            @threads << child.spawn_worker(child_process_id)
            child.join_threads(@threads)
          rescue => e
            puts "Child process error: #{e.message}"
            exit(1)
          end
        end
      end
    end
  end
end
