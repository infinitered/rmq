class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_label_kitchen_sink(st)
    st.text = 'rmq is awesome'
    st.font = font.system(12)
    st.color = color.black
    st.text_alignment = :center
    st.number_of_lines = :unlimited
    st.adjusts_font_size = true
    st.resize_to_fit_text
    st.size_to_fit
    st.line_break_mode = :word_wrapping
  end

  def ui_label_color(st)
    st.text_color = color.blue
  end

  def ui_label_centered(st)
    ui_label_kitchen_sink(st)
    st.text_alignment = :centered
  end

  def ui_label_attributed_string(st)
    st.attributed_text = NSAttributedString.alloc.initWithString("RMQ")
  end
end

describe 'stylers/ui_label' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UILabel
  end

  behaves_like "styler"

  it 'should apply a style with every UILabelStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink).get

    view.tap do |v|
      v.text.should == 'rmq is awesome'
      v.font.should == UIFont.systemFontOfSize(12)
      v.color.should == UIColor.blackColor
      v.textAlignment.should == NSTextAlignmentCenter
      v.adjustsFontSizeToFitWidth.should == true
      v.size.width.should > 0
      v.numberOfLines.should == 0
      v.lineBreakMode.should == NSLineBreakByWordWrapping
    end

  end

  it 'allows adjusts_font_size_to_fit_width alias' do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink)
    view.style do |st|
      st.adjusts_font_size.should == true

      st.adjusts_font_size_to_fit_width = false

      st.adjusts_font_size_to_fit_width.should == false
      st.adjusts_font_size.should == false
    end
  end

  it 'allows color set with `text_color`' do
    view = @vc.rmq.append!(@view_klass, :ui_label_color)
    view.textColor.should == rmq.color.blue
  end

  it 'should use :centered as an alias for :center' do
    view = @vc.rmq.append(@view_klass, :ui_label_centered).get

    view.tap do |v|
      v.textAlignment.should == NSTextAlignmentCenter
    end
  end

  it "applies an attributed string" do
    view = @vc.rmq.append(@view_klass, :ui_label_attributed_string).get

    view.tap do |v|
      v.text.should == 'RMQ'
    end
  end

  it "allows setting line_break_mode to a symbol or constant" do
    view = @vc.rmq.append(@view_klass, :ui_label_attributed_string)

    view.style do |st|
      st.line_break_mode = :char_wrapping
    end
    view.get.lineBreakMode.should == NSLineBreakByCharWrapping

    view.style do |st|
      st.line_break_mode = NSLineBreakByTruncatingHead
    end
    view.get.lineBreakMode.should == NSLineBreakByTruncatingHead

  end

  it "should resize height larger when asked" do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink)

    view.style do |st|
      st.frame = {
        w: 200,
        h: 5
      }
      st.text = "Testing this thing with a really long string so that it clips but then will resize to fit properly."
    end

    old_size = view.get.frame.size
    old_size.should == CGSizeMake(200,5)

    view.style {|st| st.resize_height_to_fit}

    size = view.get.frame.size
    size.width.should == 200
    size.height.should > 5
    size.height.should < Float::MAX

    # Set the height to zero and try again
    view.style do |st|
      st.frame = {
        h: 0
      }
    end
    view.style {|st| st.resize_height_to_fit}
    view.get.frame.size.height.should > 0
  end

  it "should resize height smaller when asked" do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink)

    view.style do |st|
      st.frame = {
        w: 150,
        h: 5000
      }
      st.text = "This is a small label."
    end

    old_size = view.get.frame.size
    old_size.should == CGSizeMake(150,5000)

    view.style {|st| st.resize_height_to_fit}

    size = view.get.frame.size
    size.width.should == 150
    size.height.should < 5000
    size.height.should > 0
  end
end

