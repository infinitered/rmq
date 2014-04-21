describe 'grid' do

  before do
    #@vc = UIViewController.alloc.init
    #@viewq = @vc.rmq.append(UIView)
  end

  should 'have application default grid' do
    grid = rmq.app.grid
    grid.should != nil
  end
end
