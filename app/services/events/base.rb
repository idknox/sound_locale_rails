module Events
  class Base
    def get(path)
      @response ||= @connector.get(path)
    end
  end
end