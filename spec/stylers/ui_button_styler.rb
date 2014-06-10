class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_button_kitchen_sink(st)
    st.text = 'foo'
    st.font = font.system(12)
    st.color = color.red
    st.image_normal = image.resource('logo')
    st.image_highlighted = image.resource('logo')
    st.title_edge_insets = [1.0, 0, 2.0, 3.0]
  end

end

describe 'stylers/ui_button' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIButton
  end

  behaves_like "styler"

  it 'should apply a style with every UIButtonStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink).get

    view.tap do |v|
      # TODO
      1.should == 1
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
