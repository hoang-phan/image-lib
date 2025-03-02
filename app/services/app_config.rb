class AppConfig
  MAXES = {
    "minrate" => 5,
    "maxrate" => 5
  }
  DEFAULTS = {
    "minrate" => 0,
    "maxrate" => MAXES["maxrate"]
  }

  class << self
    def get(name)
      (Rails.cache.read(name) || DEFAULTS[name]).to_i
    end

    def set(name, value, cascading: false)
      Rails.cache.write(name, value)
      set_other(name, value) if cascading
    end

    def increment(name, cascading: false)
      new_value = (get(name) + 1) % (MAXES[name] + 1)
      set(name, new_value, cascading:)
    end

    def set_other(name, value)
      case name
      when "minrate"
        set("maxrate", value) if get("maxrate") < value
      when "maxrate"
        set("minrate", value) if get("minrate") > value
      end
    end
  end
end