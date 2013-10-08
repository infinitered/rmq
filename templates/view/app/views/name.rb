class <%= @name_camel_case %> < UIView

  def rmq_did_create(self_in_rmq)

    self_in_rmq.tap do |q|
      q.apply_style :<%= @name %>

      # Add subviews here, like so:
      #q.append(UILabel, :some_label)
    end

  end

end


# To style this view include its stylesheet at the top of each controller's 
# stylesheet that is going to use it:
#   class SomeStylesheet < ApplicationStylesheet 
#     include <%= @stylesheet_name %>

# Another option is to use your controller's stylesheet to style this view. This
# works well if only one controller uses it. If you do that, delete the 
# view's stylesheet with:
#   rm app/stylesheets/views/<%= @name %>.rb
