module BackgroundJobber
  class Child
    def spawn_worker
      Thread.new do
        worker = Worker.new
        worker.poll
      end
    end
  end
end