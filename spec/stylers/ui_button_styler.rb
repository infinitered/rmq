class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_button_kitchen_sink(st)
    st.text = 'foo'
    st.attributed_text = NSAttributedString.alloc.initWithString("RMQ")
    st.font = font.system(12)
    st.color = color.red
    st.color_highlighted = color.blue
    st.image_normal = image.resource('logo')
    st.image_highlighted = image.resource('Icon')
    st.background_image_normal = image.resource('Default')
    st.background_image_highlighted = image.resource('logo')
    st.background_image_selected = image.resource('Icon')
    st.text_highlighted = 'bar'
    st.attributed_text_highlighted = NSAttributedString.alloc.initWithString("RMQ Highlighted")
    st.adjust_image_when_highlighted = true
    st.selected = true
  end

end

describe 'stylers/ui_button' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIButton
  end

  behaves_like "styler"

  it 'should apply a style with every UIButtonStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink).get

    view.tap do |v|
      view.titleForState(UIControlStateNormal).should == "foo"
      view.titleForState(UIControlStateHighlighted).should == 'bar'
      view.attributedTitleForState(UIControlStateNormal).should == NSAttributedString.alloc.initWithString("RMQ")
      view.attributedTitleForState(UIControlStateHighlighted).should == NSAttributedString.alloc.initWithString("RMQ Highlighted")
      view.titleLabel.font.should == UIFont.systemFontOfSize(12)
      view.titleColorForState(UIControlStateNormal).should == UIColor.redColor
      view.titleColorForState(UIControlStateHighlighted).should == UIColor.blueColor
      view.imageForState(UIControlStateNormal).should == @vc.rmq.image.resource('logo')
      view.imageForState(UIControlStateHighlighted).should == @vc.rmq.image.resource('Icon')
      view.backgroundImageForState(UIControlStateNormal).should == @vc.rmq.image.resource('Default')
      view.backgroundImageForState(UIControlStateHighlighted).should == @vc.rmq.image.resource('logo')
      view.backgroundImageForState(UIControlStateSelected).should == @vc.rmq.image.resource('Icon')
      view.adjustsImageWhenHighlighted.should == true
      view.isSelected.should == true
    end

  end

  describe "bordered button extensions" do
    before { @view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink) }

    describe "border width" do
      before{ @view.style{|st| st.border_width = 2} }

      it 'should be able to add a border to a button' do
        @view.get.layer.borderWidth.should == 2
      end

      it "can get a border width for a button" do
        bw = nil
        @view.style{|st| bw = st.border_width}
        bw.should == 2
      end
    end

    describe "corner radius" do
      before{ @view.style{|st| st.corner_radius = 10} }

      it "sets the corner radius" { @view.get.layer.cornerRadius.should == 10 }
      it "gets the corner radius" do
        cr = nil
        @view.style{|st| cr = st.corner_radius}
        cr.should == 10
      end
    end

    describe "border colors" do
      before{ @view.style{|st| st.border_color = rmq.color.blue} }

      it "sets the correct number of color components" do
        CGColorGetNumberOfComponents(@view.get.layer.borderColor).should >= 4
      end

      it "sets the right colors" do
        color = nil
        @view.style{|st| color = st.border_color}
        components = CGColorGetComponents(color)

        # R=0, G=0, B=1 A=1

        components[0].to_i.should == 0
        components[1].to_i.should == 0
        components[2].to_i.should == 1
        components[3].to_i.should == 1
      end
    end
  end

  describe "title edge insets" do
    before {
      @view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink)
      @view.style{|st| st.title_edge_insets = UIEdgeInsetsMake(0, 10.0, 0, 0)}
    }

    it "returns the set inset" do
      inset = nil
      @view.style{|st| inset = st.title_edge_insets}
      inset.should == UIEdgeInsetsMake(0, 10.0, 0, 0)
    end

    it "sets the inset of the button title" do
      @view.get.titleEdgeInsets.should == UIEdgeInsetsMake(0, 10.0, 0, 0)
    end

    it "can be set with an array of inset values" do
      @view.style{|st| st.title_edge_insets = [1.0, 10.0, 0, 0]}
      @view.get.titleEdgeInsets.should == UIEdgeInsetsMake(1.0, 10.0, 0, 0)
    end

  end

  describe "image edge insets" do
    before {
      @view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink)
      @view.style{|st| st.image_edge_insets = UIEdgeInsetsMake(0, 10.0, 0, 0)}
    }

    it "returns the set inset" do
      inset = nil
      @view.style{|st| inset = st.image_edge_insets}
      inset.should == UIEdgeInsetsMake(0, 10.0, 0, 0)
    end

    it "sets the inset of the button image" do
      @view.get.imageEdgeInsets.should == UIEdgeInsetsMake(0, 10.0, 0, 0)
    end

    it "can be set with an array of inset values" do
      @view.style{|st| st.image_edge_insets = [1.0, 10.0, 0, 0]}
      @view.get.imageEdgeInsets.should == UIEdgeInsetsMake(1.0, 10.0, 0, 0)
    end

  end
end
