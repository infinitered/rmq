class <%= @name_camel_case %> < UIView

  def rmq_build
    q = rmq(self)
    q.apply_style :<%= @name %>

    # Add subviews here, like so:
    # q.append(UILabel, :some_label)
    # -or-
    # @submit_button = q.append(UIButon, :submit).get
  end

end


# To style this view include its stylesheet at the top of each controller's
# stylesheet that is going to use it:
#   class SomeStylesheet < ApplicationStylesheet
#     include <%= @name_camel_case %>Stylesheet

# Another option is to use your controller's stylesheet to style this view. This
# works well if only one controller uses it. If you do that, delete the
# view's stylesheet with:
#   rm app/stylesheets/views/<%= @name %>.rb
