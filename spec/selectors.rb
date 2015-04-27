describe 'selectors' do
  before do
    @vc = UIViewController.alloc.init
    @root_view = @vc.view

    @views_hash = {
      v_0: {
        klass: UIView,
        subs: {
          v_0: {
            klass: UIView,
            subs: {
              v_0: { klass: UIView, subs: { } },
              v_1: { klass: UIImageView, subs: { } },
              v_2: { klass: UILabel, subs: { } },
              v_3: { klass: UIView, subs: { } }
            }
          },
          v_1: { klass: UILabel, subs: { } },
          v_2: { klass: UIImageView, subs: { } }
        }
      },
      v_1: { klass: UILabel, subs: { } },
      v_2: { klass: UILabel, subs: { } },
      v_3: {
        klass: UIView,
        subs: {
          v_0: { klass: UIButton, subs: { } },
          v_1: { klass: UIView, subs: { } },
          v_2: {
            klass: UIView,
            subs: {
              v_0: { klass: UIView,
                subs: {
                  v_0: { klass: UILabel, subs: { } },
                  v_1: { klass: UILabel, subs: { } },
                  v_2: { klass: UIImageView, subs: { } },
                  v_3: { klass: UILabel, subs: { } },
                  v_4: { klass: UIView, subs: { } }
                }
              }
            }
          }
        }
      }
    }

    @views_hash = hash_to_subviews(@root_view, @views_hash)
  end

  it 'should set and get selectors' do
    rmq = RubyMotionQuery::RMQ.new
    rmq.selectors = [UIView, :foo]
    rmq.selectors.should == [UIView, :foo]
  end

  it 'should normalize selectors' do
    a = [UIView,[UIImageView, :hidden, {text: 'foo'}],'stylename']
    rmq = RubyMotionQuery::RMQ.new
    rmq.selectors = a
    rmq.selectors.should == [UIView, UIImageView, :hidden, {text: 'foo'},'stylename']
  end

  describe 'class' do
    it 'should match based on Class' do
      image_views = @vc.rmq(UIImageView)
      image_views.selectors.should == [UIImageView]
      image_views.context.should == @vc
      image_views.length.should == 3
      image_views.each do |v|
        v.is_a?(UIImageView).should == true
      end
    end

    it 'should select with multiple Class selectors' do
      views = @vc.rmq(UIImageView, UILabel)
      views.selectors.should == [UIImageView, UILabel]

      views.length.should == 10
      views.each do |v|
        (v.is_a?(UIImageView) || v.is_a?(UILabel) ).should == true
      end
    end
  end

  describe 'symbol' do
    before do
      @vc.rmq.stylesheet = StyleSheetForSelectorTests

      @a = @vc.rmq.append(UIView, :a_style).tag(:a)
      @a.is_a?(RubyMotionQuery::RMQ).should == true

      @b = @vc.rmq.append(UIView, :b_style).tag(:b)
      @b_subview = @b.append(UIView).tag(:b_subview)

      @c = @vc.rmq.append(UIView, :c_style).tag(:b)
    end

    it 'should return empty rmq if invalid tag' do
      @vc.rmq(:doesnt_exist).length.should == 0
    end

    it 'should return view based on tag' do
      @vc.rmq(:a).get.should == @a.get
    end

    it 'should get tags and other selectors together' do
      @vc.rmq(:b, @a.get).length.should == 3
    end

    it 'should return all views using multiple tag selectors' do
      @vc.rmq(:a, :b, :b_subview).tap do |q|
        q.length.should == 4
        ary = q.get
        ary.should.include(@b_subview.get)
        ary.should.include(@a.get)
        ary.should.include(@b.get)
        ary.should.include(@c.get)
      end
    end

    it 'should return view based on style_name' do
      @vc.rmq(:a_style).get.should == @a.get
    end

    it 'should return all views using multiple style_name selectors' do
      @vc.rmq(:a_style, :no_such_style_name, :b_style, :c_style).tap do |q|
        q.length.should == 3
        ary = q.get
        ary.should.not.include(@b_subview.get)
        ary.should.include(@a.get)
        ary.should.include(@b.get)
        ary.should.include(@c.get)
      end

    end
  end

  describe 'hash' do
    before do
      @vc.rmq(UILabel).each do |label|
        label.text = 'test text'
      end
      @vc.rmq(UIButton).first.get.alpha = 0.5
      @vc.rmq(UIImageView).first.get.alpha = 0.5
    end
    it 'should return empty rmq if no view has the attribute value selected' do
      @vc.rmq(text: 'nothing').length.should == 0
    end

    it 'should return all views with specific attribute value' do
      @vc.rmq(text: 'test text').length.should == @vc.rmq(UILabel).length
    end

    it 'should return this attribute or that attribute value' do
      @vc.rmq(alpha: 0.5).length.should == 2
      @vc.rmq(text: 'test text').length.should == 7
      @vc.rmq(text: 'test text', alpha: 0.5).length.should == 9
      @vc.rmq(UIImageView, :bad_tag, String, text: 'test text', alpha: 0.5).length.should == 11
    end

    it 'should return based on sub attributes, ie: view.origin.x' do
      # TODO, do when implementing
      1.should == 1
    end
  end

  describe 'integer' do
    it 'should return based on object id' do
      id = @views_hash[:v_0][:subs][:v_1][:view].object_id
      id2 = @views_hash[:v_0][:subs][:v_2][:view].object_id

      @vc.rmq(id).get.object_id.should == id
      @vc.rmq(id2).get.object_id.should == id2
      @vc.rmq(id2, id).length.should == 2
      @vc.rmq(id2, id, 5, 666, 89).length.should == 2
      @vc.rmq(id, id2, String, 71, :foo).length.should == 2
    end
  end

end


class StyleSheetForSelectorTests < RubyMotionQuery::Stylesheet
  def a_style(st)
  end

  def b_style(st)
  end

  def b_subview(st)
  end

  def c_style(st)
  end

end
