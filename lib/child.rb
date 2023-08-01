module BackgroundJobber
  class Child

    # spawn worker thread
    def spawn_worker(queue_name = 'default', child_process_id)
      Thread.new do
        begin
          worker = Worker.new
          worker.poll(queue_name, child_process_id)
        rescue => e
          puts "Worker thread error: #{e.message}"
        end
      end
    end

    def join_threads(threads)
      threads.each do |thread|
        thread.join
      end
    end
  end
end