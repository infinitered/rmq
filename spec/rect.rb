describe 'rect' do

  describe 'updating rect of view' do
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

      apply_frame h: 20, fb: 20
      @view.frame.origin.y.should == rmq.device.height - 40
    end

    def verify_view_with_superview_frame
      @view.frame.origin.x.should == 1
      @view.frame.origin.y.should == 2
      @view.frame.size.width.should == 4
      @view.frame.size.height.should == 5
    end

    it 'should not apply fr or fb if view does not have a superview' do
      apply_frame l: 1 , t: 2, w: 4, h: 5
      rmq(@view).remove
      verify_view_with_superview_frame
      apply_frame fr: 100
      verify_view_with_superview_frame
      apply_frame fb: 200
      verify_view_with_superview_frame
      apply_frame fr: 20, fb: 30
      verify_view_with_superview_frame
    end

    it 'should change w when fr and l are set' do
      w = @view.frame.size.width
      apply_frame fr: 100, l: 30
      new_w = @view.frame.size.width
      w.should != new_w
      new_w.should == rmq.device.width - 100 - 30
    end

    it 'should change h when fb and t are set' do
      h = @view.frame.size.height
      apply_frame fb: 50, t: 30
      new_h = @view.frame.size.height
      h.should != new_h
      new_h.should == rmq.device.height - 50 - 30
    end

    it 'should change l when fr and w are set' do
      l = @view.frame.origin.x
      apply_frame fr: 110, w: 50
      new_l = @view.frame.origin.x
      l.should != new_l
      new_l.should == rmq.device.width - 110 - 50
    end

    it 'should change t when fb and h are set' do
      t = @view.frame.origin.y
      apply_frame fb: 90, h: 70
      new_t = @view.frame.origin.y
      t.should != new_t
      new_t.should == rmq.device.height - 90 - 70
    end

    it 'should change left when right is changed (and not from_right)' do
      apply_frame l: 10 , t: 20, w: 40, h: 50
      l = @view.frame.origin.x
      l.should == 10
      h = @view.frame.size.height
      w = @view.frame.size.width
      w.should == 40
      h.should == 50

      apply_frame r: 60

      new_l = @view.frame.origin.x
      @view.frame.size.height.should == h
      @view.frame.size.width.should == w 
      l.should != new_l
      new_l.should == 60 - 40

      apply_frame right: 50
      @view.frame.origin.x.should == 50 - 40
    end

    it 'should change top when bottom is changed (and not from_bottom)' do
      apply_frame l: 20 , t: 30, w: 50, h: 60
      t = @view.frame.origin.y
      t.should == 30
      w = @view.frame.size.width
      h = @view.frame.size.height
      w.should == 50
      h.should == 60

      apply_frame b: 76 

      @view.frame.size.height.should == h
      @view.frame.size.width.should == w 
      new_t = @view.frame.origin.y
      t.should != new_t
      new_t.should == 76 - 60

      apply_frame bottom: 66 
      @view.frame.origin.y.should == 66 - 60
    end

    it 'should change width when left and right are both changed (and width is not changed)' do
      apply_frame l: 20 , t: 30, w: 300, h: 60
      w = @view.frame.size.width
      apply_frame r: 100, l: 49 
      new_w = @view.frame.size.width
      w.should != new_w
      new_w.should == 100 - 49
    end

    it 'should change height when top and bottom are both changed (and height is not changed)' do
      apply_frame l: 20 , t: 30, w: 300, h: 60
      h = @view.frame.size.height
      apply_frame b: 100, t: 49 
      new_h = @view.frame.size.height
      h.should != new_h
      new_h.should == 100 - 49
    end

    it 'should change width when left and from_right are both changed (and width is not changed)' do
      # TODO
      1.should == 1
    end

    it 'should change height when top and from_bottom are both changed (and height is not changed)' do
      # TODO
      1.should == 1
    end

    it 'should use only top and height if top, height, and bottom are changed, ignoring bottom' do
      apply_frame l: 40 , t: 42, w: 43, h: 44
      apply_frame t: 100, h: 200, b: 120 
      @view.frame.origin.x.should == 40
      @view.frame.origin.y.should == 100 
      @view.frame.size.width.should == 43 
      @view.frame.size.height.should == 200
    end

    it 'should use only left and width if left, width, and right are changed, ignoring right' do
      apply_frame l: 40 , t: 42, w: 43, h: 44
      apply_frame l: 100, w: 200, r: 120 
      @view.frame.origin.x.should == 100
      @view.frame.origin.y.should == 42 
      @view.frame.size.width.should == 200 
      @view.frame.size.height.should == 44 
    end

    it 'should set frame to full width and height with :full' do
      apply_frame :full
      @view.frame.should == @view.superview.bounds
    end

    it 'should set left when centering horizontally' do
      apply_frame l: 140 , t: 142, w: 143, h: 144, centered: :horizontal

      @view.frame.origin.y.should == 142 
      @view.frame.size.width.should == 143 
      @view.frame.size.height.should == 144 

      @view.frame.origin.x.should == (@view.superview.bounds.size.width / 2) - (143 / 2)
    end

    it 'should set top when centering vertically' do
      apply_frame l: 140 , t: 142, w: 143, h: 144, centered: :vertical

      @view.frame.origin.x.should == 140 
      @view.frame.size.width.should == 143 
      @view.frame.size.height.should == 144 

      @view.frame.origin.y.should == (@view.superview.bounds.size.height / 2) - (144 / 2)
    end

    it 'should set top and left when centering both' do
      apply_frame l: 140 , t: 142, w: 143, h: 144

      # We'll create a subview inside @view to test if all is good if superview isn't :full
      view_2 = rmq(@view).append(UIView).layout(l: 5, t: 6, w: 7, h: 8, centered: :both).get

      @view.frame.size.width.should == 143 
      @view.frame.size.height.should == 144 

      view_2.frame.size.width.should == 7 
      view_2.frame.size.height.should == 8 

      view_2.frame.origin.x.should == (@view.bounds.size.width / 2) - (7 / 2)
      view_2.frame.origin.y.should == (@view.bounds.size.height / 2) - (8 / 2)
    end

    it 'should set frame given Rect instance' do
      # TODO
      1.should == 1
    end

    it 'should set frame given CGRect instance' do
      # TODO
      1.should == 1
    end

    it 'should set frame given CGSize instance' do
      # TODO
      1.should == 1
    end

    it 'should set frame given CGPoint instance' do
      # TODO
      1.should == 1
    end

    it 'should set frame given various arrays' do
      #apply_frame [1, 2, 3, 4]
      #@view.frame.origin.x.should == 1
      #@view.frame.origin.y.should == 2 
      #@view.frame.size.width.should == 3
      #@view.frame.size.height.should == 4 

      #apply_frame [[5, 6], [7, 8]]
      #@view.frame.origin.x.should == 5
      #@view.frame.origin.y.should == 6 
      #@view.frame.size.width.should == 7
      #@view.frame.size.height.should == 8 
    
      #apply_frame [9, 10]
      #@view.frame.origin.x.should == 9
      #@view.frame.origin.y.should == 10 
      #@view.frame.size.width.should == 7
      #@view.frame.size.height.should == 8 
    end
  end

  describe 'initialization' do
    # TODO

    # apply_to_frame
    # apply_to_bounds
  end

  describe 'misc' do
    before do
      @vc = UIViewController.alloc.init
      @view = @vc.rmq.append(UIView).get
      apply_frame l: 44 , t: 55, w: 66, h: 77
      @rect = RubyMotionQuery::Rect.frame_for_view(@view)
    end

    def apply_frame(new_frame)
      RubyMotionQuery::Rect.update_view_frame(@view, new_frame)
    end

    it 'should have read only access to various attributes' do
      @rect.l.should == 44
      @rect.left.should == 44
      @rect.t.should == 55
      @rect.top.should == 55
      @rect.width.should == 66
      @rect.w.should == 66
      @rect.height.should == 77
      @rect.h.should == 77
      @rect.bottom.should == 132
      @rect.b.should == 132
      @rect.right.should == 110
      @rect.r.should == 110

      @rect.from_bottom.should == rmq.device.height - 132
      @rect.fb.should ==  rmq.device.height - 132 
      @rect.from_right.should ==  rmq.device.width - 110
      @rect.fr.should ==  rmq.device.width - 110

      @rect.origin.should == @view.origin
      @rect.size.should == @view.size
      @rect.z_position.should == @view.layer.zPosition
      @rect.z_order.should == 0

      # TODO check to make sure they are read-only
    end

    it 'should convert to cgrect' do
      @rect.to_cgrect.should == @view.frame
    end

    it 'should convert to cgpoint' do
      @rect.to_cgpoint.should == @view.origin
    end

    it 'should convert to cgsize' do
      @rect.to_cgsize.should == @view.size
    end

    it 'should convert to array' do
      @rect.to_a.should == [44,55,66,77]
    end

    it 'should convert to hash' do
      @rect.to_h.should == {left: 44, top: 55, width: 66, height: 77}
    end

    it 'should show nice inspect' do
      @rect.inspect.should == "Rect {l: 44, t: 55, w: 66, h: 77}"
    end
  end

  describe 'previous' do
    before do
      @vc = UIViewController.alloc.init
      @view = @vc.rmq.append(UIView).get
      @view_2 = @vc.rmq.append(UIView).get
      @view_3 = @vc.rmq.append(UIView).get
    end
    
    it 'should set top to previous views bottom, plus margin, using below_prev' do
      rmq(@view).layout(l: 10, t: 20, w: 30, h: 40)
      rmq(@view_2).layout(l: 10, below_prev: 10, w: 30, h: 40)

      @view_2.frame.origin.y.should == 20 + 40 + 10

      rmq(@view_3).layout(l: 10, bp: 11, w: 30, h: 40)
      @view_3.frame.origin.y.should == @view_2.frame.origin.y + 40 + 11
    end

    it 'should set top to previous views top, minus margin, using above_prev' do
      rmq(@view).layout(l: 10, t: 200, w: 30, h: 40)
      rmq(@view_2).layout(l: 10, above_prev: 7, w: 30, h: 60)

      @view_2.frame.origin.y.should == 200 - 60 - 7

      rmq(@view_3).layout(l: 10, ap: 17, w: 30, h: 70)
      @view_3.frame.origin.y.should == @view_2.frame.origin.y - 70 - 17
    end

    it 'should set left to previous views right, plus margin, using right_of_prev' do
      rmq(@view).layout(l: 10, t: 200, w: 30, h: 40)
      rmq(@view_2).layout(t: 210, w: 30, h: 60, rop: 15)

      @view_2.frame.origin.x.should == 10 + 30 + 15
    end

    it 'should set left to previous views left, minus margin, using left_of_prev' do
      rmq(@view).layout(l: 250, t: 200, w: 30, h: 40)
      rmq(@view_2).layout(t: 210, w: 40, h: 60, lop: 18)

      @view_2.frame.origin.x.should == 250 - 40 - 18
    end
  end

  describe 'and grid' do
    before do
      @vc = UIViewController.alloc.init
      @view = @vc.rmq.append(UIView).get
    end

    # TODO
  end

  describe 'rmq instance frame' do
    before do
      @vc = UIViewController.alloc.init
      @view = @vc.rmq.append(UIView).layout(l: 44 , t: 55.23, w: 66, h: 77).get
      @view_2 = @vc.rmq.append(UIView).layout(l: 144 , t: 155, w: 166, h: 177).get
    end

    it 'should get rect instance for a single selected view with .frame' do
      rect = rmq(@view).frame
      rect.class.should == RubyMotionQuery::Rect
      rect.left.should == 44
    end

    it 'should get array of rect instances when multiple views are selected using .frame' do
      rects = rmq(@view,@view_2).frame
      rects.class.should == Array
      rects.length.should == 2
      rects.each do |rect|
        rect.class.should == RubyMotionQuery::Rect
      end
      rects.first.top.should == 55.23
    end

    it 'should set frame with = when a single view is selected' do
      @view.origin.x.should == 44

      rmq(@view).frame = {l: 4, t: 5, w: 6, h: 7}
      @view.origin.x.should == 4
      @view.origin.y.should == 5
      @view.size.width.should == 6
      @view.size.height.should == 7
    end

    it 'should set frame with = when a multiple views are selected' do
      @view.origin.x.should == 44
      @view_2.origin.x.should == 144

      rmq(@view, @view_2).frame = {l: 4, t: 5, w: 6, h: 7}
      @view.origin.x.should == 4
      @view.origin.y.should == 5
      @view.size.width.should == 6
      @view.size.height.should == 7

      @view_2.origin.x.should == 4
      @view_2.origin.y.should == 5
      @view_2.size.width.should == 6
      @view_2.size.height.should == 7
    end
  end
end
