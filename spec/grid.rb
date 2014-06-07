describe 'grid' do

  before do
    @grid = RubyMotionQuery::Grid.new({
      num_columns: 10,
      column_gutter: 8,
      content_left_margin: 7,
      content_right_margin: 8,
      content_top_margin: 5,
      content_bottom_margin: 6,
      num_rows: 5,
      row_gutter: 10
    })
  end

  should 'have application default grid' do
    rmq.app.grid.should != nil
  end

  should 'be able to change apps default grid' do
    rmq.app.grid.tap do |g|
      g.content_left_margin = 1
      g.content_right_margin = 2
      g.content_top_margin = 3
      g.content_bottom_margin = 4
      g.num_columns = 5
      g.column_gutter = 6
      g.num_rows = 7
      g.row_gutter = 8

      g.content_left_margin.should == 1
      g.content_right_margin.should == 2
      g.content_top_margin.should == 3
      g.content_bottom_margin.should == 4

      g.num_columns.should == 5
      g.column_gutter.should == 6
      g.num_rows.should == 7
      g.row_gutter.should == 8
    end
  end

  should 'clear cache when changing settings' do
    was_row = @grid['1:3']
    was_column = @grid['a:d']
    @grid.num_columns = 5
    @grid['1:3'].should == was_row
    @grid['a:d'].should != was_column
  end

  should 'return usable width' do
    gaps_between_colums = (@grid.num_columns - 1) * @grid.column_gutter
    @grid.usable_width.should == (rmq.device.screen_width - gaps_between_colums - 15)
  end

  should 'return column width' do
    @grid.column_width.should == @grid.usable_width / @grid.num_columns
  end

  should 'return usable height' do
    gaps_between_rows = (@grid.num_rows - 1) * @grid.row_gutter
    @grid.usable_height.should == (rmq.device.screen_height - gaps_between_rows - 11)
  end

  should 'return row height' do
    @grid.row_height.should == @grid.usable_height / @grid.num_rows
  end

  should 'return nil if nil is specified' do
    @grid[nil].should == nil
  end

  should 'return nil if empty string is specified' do
    @grid[''].should == nil
  end

  should 'return 1 member hash if only 1 row is specified' do
    @grid['0'].should == {t: 5}
    @grid['1'].should == {t: 5 + @grid.row_height + @grid.row_gutter}
  end

  should 'return 1 member hash if only column is specified' do
    @grid['a'].should == {l: 7}
    @grid['b'].should == {l: 7 + @grid.column_width + @grid.column_gutter}
  end

  should 'allow upper or lower case' do
    @grid['a'].should == {l: 7}
    @grid['A'].should == {l: 7}
  end

  should 'return 2 member hash if specifying 1 letter and digits' do
    @grid['a0'].should == {l: 7, t: 5}
  end

  should 'return 2 member hash if specifying 1 letter and digits with colon' do
    @grid[':a0'].should == {r: 7 + @grid.column_width, b: 5 + @grid.row_height}
    @grid[':b1'].should == {r: 61.5999755859375, b: 221.799987792969}
  end

  should 'return 4 member hash when specifying a full grid' do
    @grid['a0:a0'].should == {l: 7, t: 5, r: 7 + @grid.column_width, b: 5 + @grid.row_height}
    @grid['a0:b1'].should == {l: 7.0, t: 5.0, r: 61.5999755859375, b: 221.799987792969}
  end

  should 'return 1 member has when specifying colon and number' do
    @grid[':0'].should == {b: 5 + @grid.row_height}
  end

  should 'return 1 member has when specifying colon and letter' do
    @grid[':a'].should == {r: 7 + @grid.column_width}
  end

  should 'work with a:a' do
    @grid['a:a'].should == {l: @grid.content_left_margin, r: @grid.content_left_margin + @grid.column_width}
  end

  should 'work with a:b' do
    r = @grid.content_left_margin + @grid.column_width + @grid.column_gutter + @grid.column_width
    @grid['a:b'].should == {l: @grid.content_left_margin, r: r}
  end

  should 'return 2 member hash when specifying only column:number' do
    @grid['a:1'].should == {l: 7, b: 221.799987792969}
    @grid['b:0'].should == {l: 7 + @grid.column_width + 8, b: 5 + @grid.row_height}
  end

  should 'return 3 member hash when specifying only column|row:number' do
    @grid['a0:0'].should == {l: 7, t: 5, b: 5 + @grid.row_height}
    @grid['a0:1'].should == {l: 7, t: 5, b: 5 + @grid.row_height + 10 + @grid.row_height}
  end


  # Finish other methods
end
