class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :valid_check
  before_action :set_pages

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.where('user_id' => current_user)
    @membership = Membership.new
    @groups = Group.all
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @groups = Group.all
  end

  def full_index
    @approvals = Membership.where('approved' => false).paginate(:page => params[:page], :per_page => @pages)
  end

  # POST /memberships
  # POST /memberships.json
  def create

    @membership = Membership.new(membership_params)
    respond_to do |format|
      if @membership.group_id === nil
      redirect_to memberships_path, notice: 'You must apply for a group.'
      return
      end
      if @membership.save
        format.html { redirect_to memberships_path, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to :back, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def set_pages
     @pages = 10
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_id, :group_id, :approved)
    end
end
