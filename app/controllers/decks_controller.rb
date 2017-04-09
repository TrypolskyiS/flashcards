class DecksController < ApplicationController
  before_action :logged_in?
  before_action :find_deck, only: [:show, :edit, :upadate, :destroy]

  def index
    @decks = current_user.decks
  end

  def show; end

  def new
      @deck = current_user.decks.build
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      redirect_to root_path
      flash[:notice] = "Deck #{@deck.name} was successfly created."
    else
      render 'new'
      flash[:notice] = 'Something went wrong. Deck was not created.'
    end
  end

  def edit; end

  def update
    if @deck.update(deck_params)
      redirect_to root_path
      flash[:notice] = "Deck #{@deck.name} was successfly updated."
    else
      render 'edit'
      flash[:notice] = 'Something went wrong. Deck was not updated.'
    end
  end

  def set_current_deck
    user = User.find(current_user.id)
    user.update_attribute(:current_deck_id, params[:deck_id])
    redirect_to root_path
    flash[:notice] = 'Deck was activated.'
  end

  def destroy
    @deck.destroy
    redirect_to decks_path
  end

  private

  def deck_params
    params.require(:deck).permit(:name)
  end


  def find_deck
    @deck = current_user.decks.find(params[:id])
  end
end
