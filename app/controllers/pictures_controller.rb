class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json

  def index
    @picture_one, @picture_two = two_random()
    @pictures = Picture.all
  end

  def main
   if params[:category].blank?
     @pictures = two_random
   else
     @cat_id = Category.find_by_name(name: params[:category]).id
     @pictures = Picture.where(cat_id: @cat_id).two_random
   end
  end

  def two_random
    picture_one = Picture.find(rand(2..Picture.last.id))
    picture_two = Picture.find(rand(2..Picture.last.id))
    if picture_one.url == picture_two.url
      two_random()
    else
      return picture_one, picture_two
    end
  end

  def vote
    picture = Picture.find(params[:picture]['id'])
    picture.vote += 1
    picture.save
   redirect_to pictures_path
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end


  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  def results
    @picture = Picture.all.paginate(page: params[:page], per_page: 5)
    @picture.order!(vote: :desc)
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_picture
    @picture = Picture.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def picture_params
    params.require(:picture).permit(:title, :url, :cat_id)
  end
end
