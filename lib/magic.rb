require 'json'
require 'redis'


# Redis backed queue taht implements push and shift methods
# just like the Queue class, as redis has zero knowledge of 
# ruby objects, we serialize the tasks into json before storing
# them into the db using lpush, to fetch a task we use brpop cmd
# which grabs the last element from the list, if list.empty?, itll 
# block until a new element is available. FUnally, we look up the 
# real ruby class based on the name of the worker using Object.const_get
module Magic
  module Backend
    class Redis
      def initialize(conn = ::Redis.new)
        @conn = conn
      end

      def push(job)
        @conn.lpush('magic:queue', JSON.dump(job))
      end

      def shift
        _queue, job = @conn.brpop('magic:queue')

        payload = JSON.parse(job, symbolize_names: true)
        payload[:worker] = Object.const_get(payload[:worker])
        payload
      end
    end
  end
end
