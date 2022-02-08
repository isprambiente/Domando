# frozen_string_literal: true

# This controller manage the views refering to {Faq} model
class FaqsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_editor!
  load_and_authorize_resource
  before_action :set_view
  before_action :set_faq, only: %i[ show edit update destroy ]

  # GET /faqs or /faqs.json
  def index; end

  def list
    faqs
  end

  # GET /faqs/1 or /faqs/1.json
  def show
    @view = params[:view] || ''
    @current_ability.cannot(:manage, @faq) if @view == 'modal'
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
    @sample = Faq.accessible_by(current_ability).find(Faq.accessible_by(current_ability).pluck(:id).sample)
  end

  # GET /faqs/1/edit
  def edit; end

  # POST /faqs or /faqs.json
  def create
    @faq = Faq.new(faq_params)

    if @faq.save
      render turbo_stream: [
        turbo_stream.replace(:flashes, partial: "flashes"),
        turbo_stream.update(:yield, partial: "faqs/index")
      ]
    else
      flash.now[:error] =  write_errors(@faq)
      render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
    end
  end

  # PATCH/PUT /faqs/1 or /faqs/1.json
  def update
    if @faq.update(faq_params)
      flash.now[:success] = 'Modifica avvenuta con successo'
    else
      flash.now[:error] = write_errors(@faq)
    end
    render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
  end

  # DELETE /faqs/1 or /faqs/1.json
  def destroy

    if @faq.destroy
      flash.now[:success] = 'Cancellazione avvenuta con successo'
      render turbo_stream: [
          turbo_stream.remove("faq_#{@faq.id}"),
          turbo_stream.replace(:flashes, partial: "flashes")
        ]
    else
      flash.now[:error] = write_errors(@faq)
      render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def faq_params
      params.require(:faq).permit(:title, :content, :structure, :counter, :approve, :evidence, :active, :visibility, :created_by, :updated_by, :approved_by, category_list: [], instructions: [], models: [], files: [])
    end

    # Only allow a list of trusted parameters through.
    def filter_params
      params.fetch(:filter, {}).permit(:text, :view)
    end

    # Set callback view
    def set_view
      @view = filter_params[:view] || ''
    end

    # Set @pagy, @faqs for paginate all {User}
    def faqs
      @filters = filter_params
      @page = params[:page] || 1
      faqs = Faq.accessible_by(current_ability)
      faqs = faqs.where(structure: current_user.structure) if current_user.editor?
      faqs = faqs.where("title ilike ?", "%#{@filters[:text]}%") if @filters[:text].present?
      @pagy, @faqs = pagy(faqs, page: @page, link_extra: "data-turbo-frame='faqs'")
    end

    # deny access unless current_user is an editor
    def authenticate_editor!
      redirect_to page_path('notallowed') unless user_signed_in? && (current_user.editor? || current_user.admin?)
    end
end
