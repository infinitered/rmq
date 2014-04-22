describe 'grid' do

  before do
    #@vc = UIViewController.alloc.init
    #@viewq = @vc.rmq.append(UIView)

    @app_grid = rmq.app.grid
  end

  should 'have application default grid' do
    @app_grid.should != nil
  end
end
