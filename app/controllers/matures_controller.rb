class MaturesController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /matures
  # GET /matures.xml
  def index
    @matures = nil
    
    params[:page] ||= 1
    @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
    
    if params[:precursor_id]
      @matures = Precursor.find_rest(params[:precursor_id]).matures
    elsif params[:species_id]
      @matures = Species.find_rest(params[:species_id]).matures
    elsif params[:paper_id]
      @matures = Paper.find_rest(params[:paper_id]).matures
    elsif params[:seed_family_id]
      @matures = SeedFamily.find_rest(params[:seed_family_id]).matures
    end  

    respond_to do |format|
      format.html do
        params[:page] ||= 1
        @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
      
        if @query != ""
          @query = @query.split(' ').map{|x| x+"*"}.join(' ')
          @matures = Mature.find_with_ferret(@query, :page => params[:page], :per_page => 12, :sort => :name_for_sort,:lazy => true)
        else
          if @matures # subselect
            @matures = Mature.paginate @matures.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => :name
          else #all
            @matures = Mature.paginate :page => params[:page], :per_page => 12, :order => :name
          end
        end
      end
      format.xml do
        @matures = Matures.find(:all) if !@matures
        render :xml => @matures
      end
      format.fa do
        @matures = Matures.find(:all) if !@matures
        render :layout => false, :text => @matures.sort_by{|p| p.name}.map{|p| ">#{p.name}\r\n#{p.sequence}"}.join("\r\n")
      end
    end
  end

  # GET /matures/1
  # GET /matures/1.xml
  def show
    @mature = Mature.find_rest(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mature }
      format.fa { render :layout => false, :text => ">#{@mature.name}\r\n#{@mature.sequence}"}
    end
  end

  def auto_complete_for_search_query
    @matures = Mature.find_with_ferret(params["search"]["query"], :limit => 10, :lazy=>true, :sort => :name_for_sort)
    render :partial => "search_results"
  end
  
end
