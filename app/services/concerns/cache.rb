module Cache

  mattr_accessor :cache_store

  def self.cache_store
    @@cache_store ||= lookup_cache(:memory)
  end

  def self.cache_store=(*args)
    @@cache_store = lookup_cache(*args)
  end

  def self.lookup_cache(*args)
    args.flatten!
    type = args.shift || :memory

    case type
    when :memory
      ::ActiveSupport::Cache::MemoryStore.new(compress: true, size: 5.megabytes)
    when :dalli
      ::ActiveSupport::Cache::DalliStore.new(*args)
    end
  end

end
