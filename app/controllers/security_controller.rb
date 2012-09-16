class SecurityController < ApplicationController
  layout 'admin'
  include SecurityHelper

  def index
    @securities = SecurityScheme.all

    setSidebar(nil,nil,nil,nil,nil,nil,true)
  end

  def create
    security = SecurityScheme.new(:name => params[:name][:name],:description => params[:description][:description],:asset_type_id => BSON::ObjectId.from_string(params[:asset_type][:asset_type]),
                                  :view_restrictions => {'users' => {},'groups' => {}},
                                  :edit_restrictions => {'users' => {},'groups' => {}},
                                  :create_restrictions => {'users' => {},'groups' => {}},
                                  :delete_restrictions => {'users' => {},'groups' => {}})

    if security.save
      @securities = SecurityScheme.all
      securityReturn(security.name,"Created")
      render :template => "security/index"
    end
  end

  def view_restrictions
    @security = SecurityScheme.find(params[:id])
    setSidebar(nil,nil,nil,nil,nil,nil,true)
  end

  def add_remove_users

    @security =  SecurityScheme.find(BSON::ObjectId.from_string(params[:security_id][:security_id]))

    users = Array.new
    users.push(params[:users][:users])

    case params[:security_type][:security_type]
      when 'create'
        @security.create_restrictions['users'] = users
      when 'edit'
        @security.edit_restrictions['users'] = users
      when 'view'
        @security.view_restrictions['users'] = users
      when 'delete'
        @security.delete_restrictions['users'] = users
    end

    if @security.save
      securityReturn(@security.name,"Restrictions Updated")
      setSidebar(nil,nil,nil,nil,nil,nil,true)
      render :template => 'security/view_restrictions'
    end

  end

  def add_remove_groups

    @security =  SecurityScheme.find(BSON::ObjectId.from_string(params[:security_id][:security_id]))

    groups = Array.new
    groups.push(params[:groups][:groups])

    case params[:security_type][:security_type]
      when 'create'
        @security.create_restrictions['groups'] = groups
      when 'edit'
        @security.edit_restrictions['groups'] = groups
      when 'view'
        @security.view_restrictions['groups'] = groups
      when 'delete'
        @security.delete_restrictions['groups'] = groups
    end

    if @security.save
      securityReturn(@security.name,"Restrictions Updated")
      setSidebar(nil,nil,nil,nil,nil,nil,true)
      render :template => 'security/view_restrictions'
    end
  end

  def delete

    if SecurityScheme.destroy(BSON::ObjectId.from_string(params['security_id']))
      securityReturn('',"Deleted")
      setSidebar(nil,nil,nil,nil,nil,nil,true)
      @securities = SecurityScheme.all

      render :template => "security/index"
    end

  end
end
