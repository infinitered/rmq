module RubyMotionQuery
  class App
    class << self
      def grid
        @_app_grid ||= Grid.new(Grid::DEFAULT)
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
  # Then you can mod it: self.grid.columns = 6
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
  #   st.frame = {left: "b", top: "2", right: "d", bottom: "3"}
  #   st.origin = {l: "b", t: "2", r: "d", b: "3"}
  #   my_view.frame = some_grid['b2:d3']
  #   my_view.origin = some_grid['b2:d3']
  #   rmq.append(UIView).layout('b2:d3')                       
  #
  # @example Create a new grid inside a stylesheet by duping the app's grid
  #   self.grid = rmq.app.grid.dup
  #   # Then change the number of columns
  #   self.grid.columns = 6
  #
  # @example Creating a new grid
  #   Grid.new({
  #     columns: 10,
  #     rows: 13,
  #     column_gutter: 10,
  #     row_gutter: 10,
  #     content_left_margin: 5,
  #     content_right_margin: 5,
  #     content_top_margin: 70,
  #     content_bottom_margin: 5,
  #     status_bar_bottom: 20,
  #     nav_bar_bottom: 64
  #   })
  #
  # @example Align all your buttons left on the c column
  #   rmq(UIButon).layout('c')
  #
  # @example Log your grid
  #   rmq.app.grid.log
  #
  #   #   {:columns=>10, :rows=>13, :column_gutter=>10, :content_left_margin=>5, 
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
    attr_reader :columns, :column_gutter, :content_left_margin, :content_right_margin, 
                :content_bottom_margin, :content_top_margin, :rows, :row_gutter, 
                :status_bar_bottom, :nav_bar_bottom

    DEFAULT = {
      columns: 10,
      column_gutter: 10,
      content_left_margin: 5,
      content_right_margin: 5,
      content_top_margin: 70,
      content_bottom_margin: 5,
      rows: 13,
      row_gutter: 10,
      status_bar_bottom: 20,
      nav_bar_bottom: 64
    }

    MAX_COLUMNS = 26
    MAX_ROWS = 30

    def initialize(params)
      @grid_hash = {}

      self.columns = params[:columns]
      self.rows = params[:rows]

      @column_gutter = params[:column_gutter]
      @content_left_margin = params[:content_left_margin]
      @content_right_margin = params[:content_right_margin]
      @content_top_margin = params[:content_top_margin]
      @content_bottom_margin = params[:content_bottom_margin]
      @row_gutter = params[:row_gutter]
      @status_bar_bottom = params[:status_bar_bottom]
      @nav_bar_bottom = params[:nav_bar_bottom]
    end

    def columns=(value)
      value = MAX_COLUMNS if value > MAX_COLUMNS
      @columns = value
      clear_cache
    end
    def rows=(value)
      value = MAX_ROWS if value > MAX_ROWS
      @rows = value
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

    # These are failing:
    # (main)> rmq.app.grid['a0:a0']
    #  => #<CGRect origin=#<CGPoint x=5.0 y=69.0> size=#<CGSize width=0.0 height=0.0>>
    #  (main)> rmq.app.grid['a0:a1']
    #  => #<CGRect origin=#<CGPoint x=5.0 y=69.0> size=#<CGSize width=0.0 height=38.7692260742188>>
    #  (main)>

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
    # @return integer, CGPoint, or CGRect, depending
    def [](coord)
      @grid_hash[coord] ||= begin
        if coord.is_a?(NSArray)

          l = column_lefts[coord[0]]
          t = row_tops[coord[1]]
          case coord.length
          when 2
            RubyMotionQuery::Rect.new([l, t, column_width, row_height])
          when 4
            RubyMotionQuery::Rect.new([l, t, coord[2], coord[3]])
          else
            0
          end

        else

          parts = coord.split(':')
          case parts.length
            when 0
              0
            when 1
              p1 = parts.first
              digits = p1.gsub(/\D/, '').to_i
              letter = p1.gsub(/\d/, '')

              lefts = column_lefts
              tops = row_tops

              left_i = if letter != ''
                97 - letter.ord
              else
                nil
              end
              top_i = digits

              if left_i && lefts.length > left_i && tops.length > top_i
                CGPointMake(column_lefts[left_i], row_tops[top_i])
              elsif left_i && lefts.length > left_i
                column_lefts[left_i]
              elsif tops.length > top_i
                row_tops[top_i]
              else
                0
              end
            when 2
              p1 = self[parts.first]
              p2 = self[parts.last]
              RubyMotionQuery::Rect.new([p1.x, p1.y], [p2.x - p1.x, p2.y - p1.y])
          end

        end
      end
    end

    # TODO, do this when orientation changes
    def clear_cache
      @grid_hash = {}
      @_usable_width = nil
      @_column_width = nil
      @_usable_height = nil
      @_row_height = nil
    end

    def to_h
      {
        columns: @columns,
        rows: @rows,
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

      0.upto(@columns - 1).each do |c|
        out << "#{(c+97).chr}  "
      end

      0.upto(@rows - 1).each do |r|
        out << "\n"
        out << left_m
        out << r.to_s.rjust(4)

        0.upto(@columns - 1).each do |c|
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

    def dup
      Grid.new(self.to_h)
    end

    def usable_width
      @_usable_width ||= (RMQ.device.screen_width - (@column_gutter * (@columns - 1)) - @content_left_margin - @content_right_margin)
    end

    def column_width
      @_column_width ||= usable_width / @columns
    end

    def column_lefts
      out = []
      if @columns
        0.upto(@columns - 1) do |i|
          out << (@content_left_margin + (i * @column_gutter) + (i * column_width))
        end
      end
      out
    end

    def column_rights
      column_lefts.map{|x| x + column_width}
    end

    def usable_height
      @_usable_height ||= (RMQ.device.screen_height - (@row_gutter * (@rows - 1)) - @content_top_margin - @content_bottom_margin)
    end

    def row_height
      @_row_height ||= usable_height / @rows
    end

    def row_tops
      out = []
      if @rows
        0.upto(@rows - 1) do |i|
          out << (@content_top_margin + (i * @row_gutter) + (i * row_height))
        end
      end
      out
    end
    def row_bottoms
      row_tops.map{|y| y + row_height}
    end

    private

    #def grid_hash
      #@_grid_hash ||= begin
        #h = {}

        #column_lefts.each_with_index do |x, i|
          #h["l#{(i+97).chr}".to_sym] = x 
        #end

        #column_rights.each_with_index do |x, i|
          #h["r#{(i+97).chr}".to_sym] = x 
        #end

        #row_tops.each_with_index do |y, i|
          #h["t#{(i)}".to_sym] = y 
        #end

        #row_bottoms.each_with_index do |y, i|
          #h["b#{(i)}".to_sym] = y 
        #end

        #h
      #end
    #end

  end
end
