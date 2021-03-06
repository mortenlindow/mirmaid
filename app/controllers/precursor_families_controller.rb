class PrecursorFamiliesController < ApplicationController
  layout "application"
  # GET /precursor_families
  # GET /precursor_families.xml
  def index
    @precursor_families = nil
    
    if params[:precursor_id]
      @precursor_families = [Precursor.find_rest(params[:precursor_id]).precursor_family]
    else
      # index nested resource from plugin resource
      @precursor_families = find_from_plugin_routes(:precursor_family,:many,params)
    end
    
    @precursor_families = PrecursorFamily.find(:all) if @precursor_families.nil?
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_families.to_xml(:only => PrecursorFamily.column_names) }
    end
  end

  # GET /precursor_families/1
  # GET /precursor_families/1.xml
  def show
    @precursor_family = nil

    if params[:precursor_id]
      @precursor_family = Precursor.find_rest(params[:precursor_id]).precursor_family
    else
      @precursor_family = find_from_plugin_routes(:precursor_family,:one,params)
    end

    @precursor_family = PrecursorFamily.find_rest(params[:id]) if @precursor_family.nil?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_family.to_xml(:only => PrecursorFamily.column_names) }
    end
  end
  
end
