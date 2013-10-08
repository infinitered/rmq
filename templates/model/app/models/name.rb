class <%= @name_camel_case %>
  def initialize(params = {})
  end

  def update(params = {})
    self
  end

  def delete
  end

  def save
    true
  end

  class << self
    def create(params = {})
      <%= @name_camel_case %>.new(params).tap do |<%= @name %>|
        <%= @name %>.save
      end
    end

    def find(id_or_params)
    end

    def all
      <%= @name_camel_case %>.find(:all)
    end
  end
end
