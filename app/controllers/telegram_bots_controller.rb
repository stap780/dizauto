# TelegramBotsController
class TelegramBotsController < ApplicationController
  before_action :authenticate_user!, except: %i[order]
  before_action :set_telegram_bot, only: %i[ show edit update destroy ]

  def index
    @search = TelegramBot.ransack(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @telegram_bots = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
  end

  def show; end

  def new
    if TelegramBot.exists?
      respond_to do |format|
        notice = 'у вас уже есть бот'
        flash.now[:notice] = notice
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to telegram_bots_path, notice: notice }
      end
    else
      @telegram_bot = TelegramBot.new
    end
  end

  def edit; end

  def create
    @telegram_bot = TelegramBot.new(telegram_bot_params)
    respond_to do |format|
      if @telegram_bot.save
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @telegram_bot, notice: t('.success') }
        format.json { render :show, status: :created, location: @telegram_bot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @telegram_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @telegram_bot.update(telegram_bot_params)
        flash.now[:success] = t('.success')
        format.turbo_stream do
          render turbo_stream: [
            render_turbo_flash
          ]
        end
        format.html { redirect_to @telegram_bot, notice: t('.success') }
        format.json { render :show, status: :ok, location: @telegram_bot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @telegram_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  def run
    result, message = Telegram::BotListener.call(TelegramBot.first.token)
    respond_to do |format|
      flash.now[:notice] = message
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to telegram_bots_path, status: :see_other, notice: message }
      format.json { head :no_content }
    end
  end

  # TODO: thinking about bot stop action
  def stop
    # Telegram::BotStop.call
    # respond_to do |format|
    #   flash.now[:success] = 'we stop bot'
    #   format.turbo_stream do
    #     render turbo_stream: [
    #       render_turbo_flash
    #     ]
    #   end
    #   format.html { redirect_to telegram_bots_path, status: :see_other, notice: 'we stop bot' }
    #   format.json { head :no_content }
    # end
  end

  def destroy
    @telegram_bot.destroy!

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash
        ]
      end
      format.html { redirect_to telegram_bots_path, status: :see_other, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find(params[:id])
  end

  def telegram_bot_params
    params.require(:telegram_bot).permit(:title, :token)
  end
end
