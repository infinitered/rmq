class MainController < UIViewController 

  def viewDidLoad
    super

    rmq.stylesheet = MainStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    rmq.append UIImageView, :logo
    rmq.append Section

    init_buttons
    init_benchmark_section
  end

  def init_nav
    self.title = 'Title Here'

    self.navigationItem.tap do |nav|
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                                                           target: self, action: :nav_left_button)
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                           target: self, action: :nav_right_button)
    end
  end

  def nav_left_button
    puts 'Left button'
  end

  def nav_right_button
    puts 'Right button'
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end
  # You don't have to reapply styles to all UIViews, if you want to optimize, 
  # another way to do it is tag the views you need to restyle in your stylesheet, 
  # then only reapply the tagged views, like so:
  #
  # def logo(st)
  #    st.frame = {t: 10, w: 200, h: 96}
  #    st.centered = :horizontal
  #    st.image = image.resource('logo')
  #    st.tag(:reapply_style)
  #  end
  #
  # Then here in willAnimateRotationToInterfaceOrientation
  #  rmq(:reapply_style).reapply_styles

  def init_buttons
    rmq.append(UIButton, :make_labels_blink_button).on(:tap) do |sender|
      rmq(UILabel).animations.blink
    end

    rmq.append(UIButton.buttonWithType(UIButtonTypeRoundedRect), :make_buttons_throb_button).on(:tap) do |sender|
      rmq(UIButton).not(sender).animations.throb
    end

    rmq.append(UIButton, :animate_move_button).on(:tap) do |sender|
      rmq(sender).animate( duration: 0.5, animations: -> (rmq) {
        # You really should create a new style in the stylesheet, 
        # but you can do it inline too, like so
        rmq.style do |sv|
          sv.top = rand(rmq.device.height) 
          sv.scale = 10.0
        end
      },
      completion: -> (did_finish, rmq) {
        rmq.animate( duration: 0.2, animations: -> (rmq) {
            rmq.style do |sv|
              sv.scale = 1.0
              sv.top = 230 
            end
          })
      })
    end

    rmq.append(UIButton, :collection_button).on(:touch_up) do |sender|
      controller = CollectionController.new
      rmq.view_controller.navigationController.pushViewController(controller, animated: true)
    end

    rmq.append(UIButton, :table_button).on(:touch_up) do |sender|
      controller = TableController.new
      rmq.view_controller.navigationController.pushViewController(controller, animated: true)
    end
    
  end

  def init_benchmark_section

    rmq.append(UIView, :benchmark_section).tap do |q|
    
      @title_label = q.append!(UILabel, :title_label)
      q.append(UIButton, :run_benchmarks).on(:touch_down) do |sender|

        rmq(sender).apply_style(:run_benchmarks_disabled)
        rmq.animations.start_spinner

        rmq.append(UIView, :overlay).animations.fade_in.on(:tap) do |sender|
          rmq.find(:benchmarks_results_label, :benchmarks_results_wrapper, sender).hide.remove
        end

      end.on(:touch_up) do |sender|

        rmq.append(UILabel, :benchmarks_results_wrapper).tap do |o|
          o.animations.fade_in
          o.append(UILabel, :benchmarks_results_label).get.text = benchmark
        end

        rmq(sender).apply_style(:run_benchmarks)
        rmq.animations.stop_spinner

      end
    end

  end

  def benchmark
    # This compares setting attributes directly, or using
    # rmq's stylesheets
    #
    # (A)
    # o.hidden = false
    # o.text = 'foo'
    # o.color = UIColor.whiteColor
    # o.frame.origin.x = 10
    #
    # (B)
    # def benchmark(sv)
    #   sv.hidden = false
    #   sv.text = 'foo'
    #   sv.color = color.white
    #   sv.left = 10
    # end

    o = @title_label
    num_runs = 5000

    out = ''

    start = (Time.now.to_f * 1000.0)
    0.upto(num_runs) do |i|
      o.hidden = false
      o.text = 'foo'
      o.color = UIColor.whiteColor
      o.frame.origin.x = 10
    end
    now = (Time.now.to_f * 1000.0)
    a_delta = now - start
    out << "A #{start} - #{now}\ntime: #{a_delta}ms  #{(a_delta / 1000)}s\n\n"
    
    start = (Time.now.to_f * 1000.0)
    0.upto(num_runs) do |i|
      rmq(o).apply_style(:benchmark)
    end

    now = (Time.now.to_f * 1000.0)
    b_delta = now - start
    out << "B #{start} - #{now}\ntime: #{b_delta}ms  #{(b_delta / 1000)}s\n\n"

    out << if b_delta < a_delta
      "B is #{((a_delta / b_delta) * 100) - 100}% faster than A"
    else
      "A is #{((b_delta / a_delta) * 100) - 100}% faster than B"
    end

    rmq(o).apply_style(:title_label)

    out
  end
end
