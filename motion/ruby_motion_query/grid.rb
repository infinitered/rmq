module RubyMotionQuery
  class App
    class << self
      def grid
        @_app_grid ||= Grid.new(Grid::DEFAULT)
      end
    end
  end

  class Grid
    attr_reader :columns, :column_gutter, :content_left_margin, :content_right_margin, :content_bottom_margin, 
                  :content_top_margin, :rows, :row_gutter

    DEFAULT = {
      columns: 10,
      column_gutter: 10,
      content_left_margin: 5,
      content_right_margin: 5,
      content_top_margin: 5,
      content_bottom_margin: 5,
      rows: 13,
      row_gutter: 10
    }

    def initialize(params)
      @params = params
      @columns = params[:columns]
      @column_gutter = params[:column_gutter]
      @content_left_margin = params[:content_left_margin]
      @content_right_margin = params[:content_right_margin]
      @content_top_margin = params[:content_top_margin]
      @content_bottom_margin = params[:content_bottom_margin]
      @rows = params[:rows]
      @row_gutter = params[:row_gutter]
    end

    def [](key)
      grid_hash[key] || 0
    end

    # TODO, do this when orientation changes
    def clear_cache
      @_grid_hash = nil
      @_usable_width = nil
      @_column_width = nil
    end

    def inspect
      to_h.inspect
    end

    def to_h
      grid_hash.merge(@params)
    end

    def column_lefts
      out = []
      0.upto(@columns - 1) do |i|
        out << (@content_left_margin + (i * @column_gutter) + (i * column_width))
      end
      out
    end

    def column_rights
      column_lefts.map {|x| x + column_width}
    end

    def row_tops
      # TOD
    end
    def row_buttoms
      # TOD
    end

    def usable_width
      @_usable_width ||= RMQ.device.screen_width - (@column_gutter * (@columns - 1)) - @content_left_margin - @content_right_margin
    end

    def column_width
      @_column_width ||= usable_width / @columns
    end

    private

    def grid_hash
      @_grid_hash ||= begin
        h = {}

        # Columns
        column_lefts.each_with_index do |x, i|
          h["#{(i+97).chr}".to_sym] = x 
        end

        column_rights.each_with_index do |x, i|
          h["#{(i+97).chr}_r".to_sym] = x 
        end
        
        #0.upto(@columns - 1) do |i|
          #h["g#{(i+97).chr}".to_sym] = (@content_left_margin + (i * @column_gutter) + (i * column_width))
        #end

        # Rows
        # TODO

        h
      end
    end

  end
end
