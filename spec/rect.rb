describe 'rect' do

  describe 'view_rect_updated' do
    before do
      @vc = UIViewController.alloc.init
      @view = @vc.rmq.append(UIView).get
    end

    def apply_frame(new_frame)
      RubyMotionQuery::Rect.update_view_frame(@view, new_frame)
    end

    it 'should apply left or l or x' do
      apply_frame l: 1
      @view.frame.origin.x.should == 1
      apply_frame left: 2
      @view.frame.origin.x.should == 2
      apply_frame x: 3
      @view.frame.origin.x.should == 3
    end

    it 'should apply top or t or y' do
      apply_frame t: 1
      @view.frame.origin.y.should == 1
      apply_frame top: 2
      @view.frame.origin.y.should == 2
      apply_frame y: 3
      @view.frame.origin.y.should == 3
    end

    it 'should apply width or w' do
      apply_frame w: 3
      @view.frame.size.width.should == 3
      apply_frame width: 4
      @view.frame.size.width.should == 4
    end

    it 'should apply height or h' do
      apply_frame h: 3
      @view.frame.size.height.should == 3
      apply_frame height: 4
      @view.frame.size.height.should == 4
    end

    it 'should apply with only size' do
      apply_frame w: 5, h: 6
      @view.frame.size.width.should == 5
      @view.frame.size.height.should == 6
    end

    it 'should apply with only origin' do
      apply_frame l: 7, t: 8
      @view.frame.origin.x.should == 7
      @view.frame.origin.y.should == 8
    end

    it 'should apply in any order, size and origin' do
      apply_frame l: 1, t: 2, w: 3, h: 4
      @view.frame.origin.x.should == 1
      @view.frame.origin.y.should == 2
      @view.frame.size.width.should == 3
      @view.frame.size.height.should == 4

      apply_frame w: 1, l: 2, h: 3, t: 4
      @view.frame.origin.x.should == 2
      @view.frame.origin.y.should == 4
      @view.frame.size.width.should == 1
      @view.frame.size.height.should == 3

      apply_frame h: 1, w: 2, t: 3, l: 4
      @view.frame.origin.x.should == 4
      @view.frame.origin.y.should == 3
      @view.frame.size.width.should == 2
      @view.frame.size.height.should == 1
    end

    it 'should apply from_right and fr' do
      apply_frame width: 10, from_right: 10
      @view.frame.origin.x.should == rmq.device.width - 20

      apply_frame w: 20, fr: 20
      @view.frame.origin.x.should == rmq.device.width - 40
    end

    it 'should apply from_bottom and fb' do
      apply_frame height: 10, from_bottom: 10
      @view.frame.origin.y.should == rmq.device.height - 20

      apply_frame : 20, fb: 20
      @view.frame.origin.y.should == rmq.device.height - 40
    end

    #it 'should change w when fr and l are set' do
    #end

    #it 'should change h when fb and t are set' do
    #end

    #it 'should change l when fr and w are set' do
    #end

    #it 'should change t when fb and w are set' do
    #end
 
  end
end
