# frozen_string_literal: true

# This controller manage the views refering to user
class HomeController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!, only: %i[propose propose_send]
  # load_and_authorize_resource class: Faq
  before_action :set_view, only: %i[propose show]
  before_action :set_faq, only: %i[show favorite_create favorite_destroy]
  before_action :get_user_faqs, only: %i[list favorite_list search_by_title], if: :user_signed_in?

  # GET /home/index
  #
  # render faqs
  # @return [Object] render home/index
  def index
    @categories = ActsAsTaggableOn::Tag.most_used(Settings.faq.categories_on_top)
    faqs = Faq.accessible_by(current_ability).actived.approved
    @faqs = faqs.tagged_with(@categories, any: true)
    @sample = faqs.find(faqs.pluck(:id).sample)
  end

  # GET /home/list
  #
  # render user faqs
  # @return [Object] render home/faqs
  def list
    @filters = filter_params
    @page = params[:page] || 1
    faqs = Faq.accessible_by(current_ability).actived.approved
    @evidences = faqs.evidenced.limit(Settings.faq.max_faqs_in_evidence)
    @tops = faqs.approved.where('counter > 0').on_top(Settings.faq.most_requested)
    if @filters[:text].present? || @filters[:category].present?
      faqs = faqs.search_by_title(@filters[:text].gsub(/[^\w\s]+/, ' ').remove(/[^\w\s]+/)) if @filters[:text].present?
      faqs = faqs.tagged_with(@filters[:category].remove(/[^\w\s]+/), any: true) if @filters[:category].present?
      @faqs = faqs
    end
    flash.now[:success] = 'Caricamento completato'
  end

  # GET /home/1/show
  #
  # render faq
  # @return [Object] render home/show
  def show
    FaqCounterJob.perform_later(faq: @faq)
  end

  # GET /:text
  #
  # render index
  # @return [Object] render home/index
  def search
    @filters = filter_params
    @filters[:text] = params[:text].gsub(/[^\w\s]+/, ' ').remove(/[^\w\s]+/) if params[:text].present?
    flash.now[:success] = 'Caricamento completato'
    render :index
  end

  # GET /faq/:find_by_title
  #
  # render show
  # @return [Object] render home/show
  def search_by_title
    @filters = filter_params
    @filters[:text] = params[:text].gsub(/[^\w\s]+/, ' ').remove(/[^\w\s]+/) if params[:text].present?
    faqs = Faq.accessible_by(current_ability)
    @faq = faqs.find_by("LOWER(title) = ?", @filters[:text].gsub(/[^\w\s]+/, ' ').remove(/[^\w\s]+/).downcase) if @filters[:text].present?
    FaqCounterJob.perform_later(faq: @faq)
    render :show
  end

  # GET /home/propose
  #
  # render propose
  # @return [Object] render home/propose
  def propose; end

  # GET /home/favorite
  #
  # render favorite
  # @return [Object] render home/favorite
  def favorite; end

  # GET /home/favorite_list
  #
  # render favorite_list
  # @return [Object] render home/favorite_list
  def favorite_list
    @filters = filter_params
    @page = params[:page] || 1
    @faqs = @user.faqs
    @faqs = @faqs.where("title ilike '%?%'", @filters[:text]) if @filters[:text].present?
    @pagy, @faqs = pagy(@faqs, page: @page, link_extra: "data-turbo-frame='faqs'")
  end

  def favorite_create
    if UserFaq.create(user_id: current_user.id, faq_id: @faq.id)
      flash.now[:success] = 'Faq aggiunta tra i preferiti!'
      get_user_faqs
    else
      flash.now[:success] = 'Si è verificato un errore durante la creazione della Faq nei preferiti!'
    end
    render turbo_stream: [
        turbo_stream.replace(:flashes, partial: "flashes"),
        turbo_stream.replace("faq_#{@faq.id}", partial: "home/faq", locals: {faq: @faq, user_faq_ids: @user_faq_ids})
    ]
  end


  def favorite_destroy
    user_faq = UserFaq.find_by(user_id: current_user.id, faq_id: @faq.id)
    if user_faq.present? && user_faq.destroy
      flash.now[:success] = 'Faq rimossa dai preferiti!'
      get_user_faqs
    else
      flash.now[:success] = 'Si è verificato un errore durante la cancellazione della Faq dai preferiti!'
    end
    render turbo_stream: [
        turbo_stream.replace(:flashes, partial: "flashes"),
        turbo_stream.replace("faq_#{@faq.id}", partial: "home/faq", locals: {faq: @faq, user_faq_ids: @user_faq_ids})
    ]
  end

  # POST /home/propose
  #
  # render propose_send
  # @return [Object] render home/propose_send
  def propose_send
    @author = propose_params[:author_id].present? ? User.find(propose_params[:author_id]) : ''
    if @author.present? && propose_params[:title].present?
      UserMailer.with(author: @author, propose: propose_params).propose_email.deliver_now
      User.admins.map { |u| FaqMailer.with(user: u, author: @author, propose: propose_params).propose_email.deliver_now }
      flash.now[:success] = 'Invio proposta completato'
    else
      flash.now[:error] = 'Non è stato possibile inviare la richiesta' if @author.blank?
      flash.now[:error] = 'Il titolo è obbligatorio!' if propose_params[:title].blank?
    end
    render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_faq
    @faq = Faq.accessible_by(current_ability).find(params[:id])
  end

  def get_user_faqs
    @user_faq_ids = current_user.faqs.ids
  end

  # Only allow a list of trusted parameters through.
  def faq_params
    params.require(:faq).permit(:title)
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.fetch(:filter, {}).permit(:text, :category, :view)
  end

  # Only allow a list of trusted parameters through.
  def propose_params
    params.fetch(:propose, {}).permit(:author_id, :title, :text, :visibility, :structure)
  end

  # Set callback view
  def set_view
    @view = filter_params[:view] || ''
  end

end
