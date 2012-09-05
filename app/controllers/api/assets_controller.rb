class Api::AssetsController < Api::BaseController
  before_filter :authenticate_user!
  before_filter :ensure_params_exist
  before_filter :ensure_asset_type_exist
  before_filter :ensure_asset_name_exist
  respond_to :json

  def create

    asset = Asset.new

    asset.asset_type_id = BSON::ObjectId.from_string(params[:asset][:asset_type_id])
    asset.name = params[:asset][:name]

    if asset.save
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end

  end

  protected
  def ensure_params_exist
    return unless params[:asset].blank?
    render :json=>{:success=>false, :message=>"missing asset parameter"}
  end

  protected
  def ensure_asset_type_exist
    return unless params[:asset][:asset_type_id].blank?
    render :json=>{:success=>false,:message=>"missing asset_type_id parameter"}
  end

  protected
  def ensure_asset_name_exist
    return unless params[:asset][:name].blank?
    render :json=>{:success=>false,:message=>"missing name parameter"}
  end

end
