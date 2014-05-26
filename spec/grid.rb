describe 'grid' do

  before do
    #@vc = UIViewController.alloc.init
    #@viewq = @vc.rmq.append(UIView)

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

  should 'return integer if only row is specified' do
    @grid['0'].should == {t: 5}
    @grid['1'].should == {t: 5 + @grid.row_height + @grid.row_gutter}
  end

  should 'return integer if only column is specified' do
    @grid['a'].should == {l: 7}
    @grid['b'].should == {l: 7 + @grid.column_width + @grid.column_gutter}
  end

  should 'allow upper or lower case' do
    @grid['a'].should == {l: 7}
    @grid['A'].should == {l: 7}
  end

  should 'return CGPoint if specifying 1 letter and digits' do
    @grid['a0'].should == {l: 7, t: 5}
  end

  should 'return valid hash when specifying a full grid' do
    @grid['a0:b1'].should == {l: 7, t: 5}
  end

  # ':b2' 
  # ':2'
  # ':b'
  # 'a:2'
  # 'a0:3'
end
