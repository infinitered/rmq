module RubyMotionQuery
  class App
    class << self
      def grid
        @_app_grid ||= Grid.new(Grid::DEFAULT)
      end
      def grid=(value)
        @_app_grid = value
      end
    end
  end

  class RMQ
    # Current grid, wether the current controller's or the App's gri
    def grid
      if stylesheet && (g = stylesheet.grid)
        g
      else
        App.grid
      end
    end
  end

  # A grid for layout.
  # There is an app grid at: rmq.app.grid
  # You can also have a grid per stylesheet. If none exists, the app
  # grid will be used. rmq.stylesheet.grid (this will return app's if nil).
  # If you want to create a grid for your stylesheet, you can just dup the app one
  # like so (inside the stylesheet): self.grid = rmq.app.grid.dup
  # Then you can mod it: self.grid.num_columns = 6
  #
  # @example If you want your view to be from b2 to d3, you can do any of the following:
  #
  #   #        a   b   c   d   e
  #   #      ....................
  #   #    1 . a1  b1  c1  d1  e1
  #   #      .....------------...
  #   #    2 . a2 |b2  c2  d2| e2
  #   #      .....|          |...
  #   #    3 . a3 |b3  c3  d3| e3
  #   #      .....------------...
  #   #    4 . a4  b4  c4  d4  e4
  #   #      ....................
  #   #    5 . a5  b5  c5  d5  e5
  #   #      ....................
  #
  #   st.frame = "b2:d3"
  #   st.origin = "b2:d3"
  #   st.frame = {grid: "b2", w: 100, h: 200}
  #   my_view.frame = some_grid['b2:d3']
  #   my_view.origin = some_grid['b2:d3']
  #   rmq.append(UIView).layout('b2:d3')
  #
  # @example Create a new grid inside a stylesheet by duping the app's grid
  #   self.grid = rmq.app.grid.dup
  #   # Then change the number of num_columns
  #   self.grid.num_columns = 6
  #
  # @example Creating a new grid
  #   Grid.new({
  #     num_columns: 10,
  #     num_rows: 13,
  #     column_gutter: 10,
  #     row_gutter: 10,
  #     content_left_margin: 5,
  #     content_right_margin: 5,
  #     content_top_margin: 70,
  #     content_bottom_margin: 5
  #   })
  #
  # @example Align all your buttons left on the c column
  #   rmq(UIButon).layout('c')
  #
  # @example Log your grid
  #   rmq.app.grid.log
  #
  #   #   {:num_columns=>10, :num_rows=>13, :column_gutter=>10, :content_left_margin=>5,
  #   #   :content_right_margin=>5, :content_top_margin=>5, :content_bottom_margin=>5,
  #   #   :row_gutter=>10, :status_bar_bottom=>20, :nav_bar_bottom=>64}
  #
  #   #       a  b  c  d  e  f  g  h  i  j
  #   #    0  .  .  .  .  .  .  .  .  .  .
  #   #    1  .  .  .  .  .  .  .  .  .  .
  #   #    2  .  .  .  .  .  .  .  .  .  .
  #   #    3  .  .  .  .  .  .  .  .  .  .
  #   #    4  .  .  .  .  .  .  .  .  .  .
  #   #    5  .  .  .  .  .  .  .  .  .  .
  #   #    6  .  .  .  .  .  .  .  .  .  .
  #   #    7  .  .  .  .  .  .  .  .  .  .
  #   #    8  .  .  .  .  .  .  .  .  .  .
  #   #    9  .  .  .  .  .  .  .  .  .  .
  #   #   10  .  .  .  .  .  .  .  .  .  .
  #   #   11  .  .  .  .  .  .  .  .  .  .
  #   #   12  .  .  .  .  .  .  .  .  .  .
  #
  class Grid
    attr_reader :num_columns, :column_gutter, :content_left_margin, :content_right_margin,
                :content_bottom_margin, :content_top_margin, :num_rows, :row_gutter,
                :status_bar_bottom, :nav_bar_bottom

    MAX_COLUMNS = 26
    MAX_ROWS = 30
    STATUS_BAR_BOTTOM = 20
    NAV_BAR_BOTTOM = 64

    DEFAULT = {
      num_columns: 12,
      column_gutter: 10,
      num_rows: 18,
      row_gutter: 10,
      content_left_margin: 10,
      content_right_margin: 10,
      content_top_margin: 74,
      content_bottom_margin: 10
    }

    def initialize(params)
      @grid_hash = {}
      @grid_hash_landscape = {}

      self.num_columns = params[:num_columns]
      self.num_rows = params[:num_rows]

      @column_gutter = params[:column_gutter]
      @content_left_margin = params[:content_left_margin]
      @content_right_margin = params[:content_right_margin]
      @content_top_margin = params[:content_top_margin]
      @content_bottom_margin = params[:content_bottom_margin]
      @row_gutter = params[:row_gutter]
      @status_bar_bottom = params[:status_bar_bottom] || STATUS_BAR_BOTTOM
      @nav_bar_bottom = params[:nav_bar_bottom] || NAV_BAR_BOTTOM
    end

    def num_columns=(value)
      value = MAX_COLUMNS if value > MAX_COLUMNS
      @num_columns = value
      clear_cache
    end
    def num_rows=(value)
      value = MAX_ROWS if value > MAX_ROWS
      @num_rows = value
      clear_cache
    end
    def column_gutter=(value)
      @column_gutter = value
      clear_cache
    end
    def content_left_margin=(value)
      @content_left_margin = value
      clear_cache
    end
    def content_right_margin=(value)
      @content_right_margin = value
      clear_cache
    end
    def content_top_margin=(value)
      @content_top_margin = value
      clear_cache
    end
    def content_bottom_margin=(value)
      @content_bottom_margin = value
      clear_cache
    end
    def row_gutter=(value)
      @row_gutter = value
      clear_cache
    end
    def status_bar_bottom=(value)
      @status_bar_bottom = value
      clear_cache
    end
    def nav_bar_bottom=(value)
      @nav_bar_bottom = value
      clear_cache
    end

    # @example
    #   my_grid['a1']
    #   my_grid['a']
    #   my_grid['1']
    #   my_grid['a1:f12']
    #   my_grid['a0:a0'] # Entire a0 block
    #   my_grid['a:d'] # Just width
    #   my_grid['1:4'] # Just height
    #   my_grid['a:4'] # Just width, and just height on the other end (interesting eh)
    #
    # @return hash with any combination of l:, t:, w:, or :h. Or nil if invalid
    def [](coord)
      if Device.landscape?
        @grid_hash_landscape[coord] ||= calc_coord(coord)
      else
        @grid_hash[coord] ||= calc_coord(coord)
      end
    end

    private def calc_coord(coord)
      if coord.is_a?(Array)

        l = column_lefts[coord[0]]
        t = row_tops[coord[1]]
        case coord.length
        when 2
          RubyMotionQuery::Rect.new([l, t, column_width, row_height])
        when 4
          RubyMotionQuery::Rect.new([l, t, coord[2], coord[3]])
        else
          nil
        end

      else
        return nil unless coord

        # TODO this needs refactoring once the full tests are done
        coord.gsub!(/\s/, '')
        is_end_coord = coord.start_with?(':')
        parts = coord.split(':')
        parts.reject!{|o| o == ''}

        case parts.length
          when 0
            nil
          when 1
            lefts = column_lefts
            tops = row_tops

            p1 = parts.first
            digits = p1.gsub(/\D/, '')
            if digits == ''
              digits = nil
            else
              top_i = digits.to_i
              top_i = (tops.length - 1) if top_i >= tops.length
            end

            letter = p1.gsub(/\d/, '')
            if letter == ''
              letter = nil
            else
              letter.downcase!
              left_i = (letter.ord - 97)
              left_i = (lefts.length - 1) if left_i >= lefts.length
            end

            if digits && letter
              if lefts.length > left_i && tops.length > top_i
                if is_end_coord
                  {r: lefts[left_i] + column_width, b: tops[top_i] + row_height}
                else
                  {l: lefts[left_i], t: tops[top_i]}
                end
              else
                nil
              end
            elsif digits
              if is_end_coord
                {b: tops[top_i] + row_height}
              else
                {t: tops[top_i]}
              end
            elsif letter
              if is_end_coord
                {r: lefts[left_i] + column_width}
              else
                {l: lefts[left_i]}
              end
            else
              nil
            end
          when 2
            self[parts.first].merge(self[":#{parts.last}"])
        end
      end.freeze
    end

    # TODO, do this when orientation changes
    def clear_cache
      @grid_hash = {}
      @_usable_width = nil
      @_column_width = nil
      @_usable_height = nil
      @_row_height = nil

      @grid_hash_landscape = {}
      @_usable_width_landscape = nil
      @_column_width_landscape = nil
      @_usable_height_landscape = nil
      @_row_height_landscape = nil
    end

    def to_h
      {
        num_columns: @num_columns,
        num_rows: @num_rows,
        column_gutter: @column_gutter,
        content_left_margin: @content_left_margin,
        content_right_margin: @content_right_margin,
        content_top_margin: @content_top_margin,
        content_bottom_margin: @content_bottom_margin,
        row_gutter: @row_gutter,
        status_bar_bottom: @status_bar_bottom,
        nav_bar_bottom: @nav_bar_bottom
      }
    end


    def to_s
      left_m = ""
      out = left_m.dup
      out << '      '

      0.upto(@num_columns - 1).each do |c|
        out << "#{(c+97).chr}  "
      end

      0.upto(@num_rows - 1).each do |r|
        out << "\n"
        out << left_m
        out << r.to_s.rjust(4)

        0.upto(@num_columns - 1).each do |c|
          out << "  ."
        end
      end

      out
    end
    def log
      puts self.inspect
      puts self.to_s
    end
    def inspect
      to_h.inspect
    end

    def show
      rmq(rmq.window).append(GridHudView).attr(grid: self).layout(l: 0, t: 0, fr: 0, fb: 0).enable_interaction.on(:tap) do |sender|
        rmq(sender).remove
      end
      puts '[RMQ] Tap to dismiss the grid overlay'
    end

    def dup
      Grid.new(self.to_h)
    end

    def usable_width
      unless @_usable_width
        unusable = (@column_gutter * (@num_columns - 1)) + @content_left_margin + @content_right_margin
        @_usable_width_landscape = Device.width_landscape - unusable
        @_usable_width = Device.width - unusable
      end
      Device.landscape? ? @_usable_width_landscape : @_usable_width
    end

    def column_width
      usable_width / @num_columns
    end

    def column_lefts
      out = []
      if @num_columns
        0.upto(@num_columns - 1) do |i|
          out << (@content_left_margin + (i * @column_gutter) + (i * column_width))
        end
      end
      out
    end

    def column_rights
      column_lefts.map{|x| x + column_width}
    end

    def usable_height
      unless @_usable_height
        unusable = (@row_gutter * (@num_rows - 1)) + @content_top_margin + @content_bottom_margin
        @_usable_height_landscape = Device.height_landscape - unusable
        @_usable_height = Device.height - unusable
      end
      Device.landscape? ? @_usable_height_landscape : @_usable_height
    end

    def row_height
      usable_height / @num_rows
    end

    def row_tops
      out = []
      if @num_rows
        0.upto(@num_rows - 1) do |i|
          out << (@content_top_margin + (i * @row_gutter) + (i * row_height))
        end
      end
      out
    end
    def row_bottoms
      row_tops.map{|y| y + row_height}
    end

  end

  class GridHudView < UIView
    attr_accessor :grid

    def rmq_build
      @light_text_color = rmq.color.from_rgba(213,53,82,0.6).CGColor
      @column_fill_color = rmq.color.from_rgba(213,53,82,0.1).CGColor
      @background_color = rmq.color.from_rgba(255,255,255,0.4)

      rmq(self).style do |st|
        st.background_color = @background_color
      end
    end

    def drawRect(rect)
      super

      return unless @grid

      context = UIGraphicsGetCurrentContext()
      screen_height = RMQ.device.screen_height
      screen_width = RMQ.device.screen_width

      CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
      CGContextSelectFont(context, 'Courier New', 7, KCGEncodingMacRoman)

      0.upto(@grid.num_rows - 1) do |r|
        0.upto(@grid.num_columns - 1) do |c|
          rec = @grid[[c, r]]
          CGContextSetFillColorWithColor(context, @column_fill_color)
          CGContextFillRect(context, rec.to_cgrect)
          text = "#{(c+97).chr}#{r}"
          CGContextSetFillColorWithColor(context, @light_text_color)
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 5, text, text.length)
        end
      end
    end
  end

end
